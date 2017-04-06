//
//  MGExploreViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewModel.h"
#import "MGRepositoriesModel.h"
#import "MGShowcasesModel.h"
#import "MGApiService+MGExplore.h"
#import "MGApiService+MGSearch.h"

NSString *const kTrendReposDataSourceArrayKey = @"kTrendReposDataSourceArrayKey";
NSString *const kShowcasesDataSourceArrayKey = @"kShowcasesDataSourceArrayKey";
NSString *const kPopularUsersDataSourceArrayKey = @"kPopularUsersDataSourceArrayKey";
NSString *const kPopularReposDataSourceArrayKey = @"kPopularReposDataSourceArrayKey";

@interface MGExploreViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *requestTrendReposCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestPopularUsersCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestShowcasesCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestLanguageCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestPopularReposCommand;
@property (nonatomic, strong, readwrite) NSMutableDictionary *dataSourceDict;
@property (nonatomic, strong) NSIndexSet *dataIndexSet;

@end

@implementation MGExploreViewModel

@synthesize page = _page;
@synthesize dataSource = _dataSource;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;
@synthesize fetchDataFromServiceSuccess = _fetchDataFromServiceSuccess;


- (void)initialize{
    
    self.dataSourceDict = [NSMutableDictionary dictionary];
    self.dataIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
    
    RACSubject *showcasesSB = [RACSubject subject];
    RACSubject *popularUsersSB = [RACSubject subject];
    RACSubject *trendReposSB = [RACSubject subject];
    RACSubject *popularReposSB = [RACSubject subject];
    
    @weakify(self);
    [[RACSignal zip:@[showcasesSB,popularUsersSB,
                      trendReposSB,popularReposSB]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        NSNumber *showcases = [tuple first];
        NSNumber *popularUsers = [tuple second];
        NSNumber *trendRepos = [tuple third];
        NSNumber *popularRepos = [tuple last];
        if ([showcases boolValue]&&[popularRepos boolValue]&&
            [trendRepos boolValue]&&[popularUsers boolValue]) {
            [self setFetchDataFromServiceSuccess:YES];
        }else{
            [self setFetchDataFromServiceSuccess:NO];
        }
    }];
    
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.requestTrendReposCommand execute:nil];
        [self.requestShowcasesCommand execute:nil];
        [self.requestPopularUsersCommand execute:nil];
        [self.requestPopularReposCommand execute:nil];
        return [RACSignal empty];
    }];

    self.requestShowcasesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[[[[MGApiService sharedApiService] fetchShowcases] retry:2] takeUntil:self.rac_willDeallocSignal]
                 doNext:^(NSArray *dataArr) {
            @strongify(self);
            NSArray *showcases = [MGShowcasesModel mj_objectArrayWithKeyValuesArray:dataArr];
            [self.dataSourceDict setObject:showcases forKey:kShowcasesDataSourceArrayKey];
            [showcasesSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [showcasesSB sendNext:@NO];
        }];
    }];

    self.requestPopularUsersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        return [[[[[[MGApiService sharedApiService] searchUserWithKeyWord:nil
                                              language:@"objective-c"
                                                  sort:@"followers"
                                                 order:@"desc"] retry:2]
                takeUntil:self.rac_willDeallocSignal] doNext:^(NSDictionary *dict) {
            @strongify(self);
            NSArray *popularUsers = [[[[dict valueForKey:@"items"] rac_sequence]map:^id(NSDictionary *usersDic) {
               return  [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:usersDic error:nil];
            }] array];
            [self.dataSourceDict setObject:popularUsers forKey:kPopularUsersDataSourceArrayKey];
            [popularUsersSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [popularUsersSB sendNext:@NO];
        }];
    }];

    self.requestTrendReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        return [[[[[[MGApiService sharedApiService] fetchTrendReposSince:@"weekly"
                                                                language:@"objective-c"] retry:2]
                  takeUntil:self.rac_willDeallocSignal] doNext:^(NSArray *dataArr) {
            @strongify(self);
            NSArray *trending = [[[dataArr rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class] fromJSONDictionary:repoDic error:nil];
            }] array];
            [self.dataSourceDict setObject:trending forKey:kTrendReposDataSourceArrayKey];
            [trendReposSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [trendReposSB sendNext:@NO];
        }];
    }];
    
    self.requestPopularReposCommand =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[[[[MGApiService sharedApiService] searchRepositoriesWithKeyWord:nil
                                                                         language:@"objective-c"
                                                                             sort:@"stars"
                                                                            order:@"desc"] retry:2]
                    takeUntil:self.rac_willDeallocSignal] doNext:^(NSDictionary *dict) {
            @strongify(self);
            NSArray *popularRepo = [[[[dict valueForKey:@"items"] rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class] fromJSONDictionary:repoDic error:nil];
            }] array];
            [self.dataSourceDict setObject:popularRepo forKey:kPopularReposDataSourceArrayKey];
            [popularReposSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [popularReposSB sendNext:@NO];
        }];
    }];
}
- (MGExploreCellViewModel *)configExploreRowViewModel:(MGExploreRowType)exploreRowType{
    
    NSParameterAssert([self.dataSourceDict objectForKey:kTrendReposDataSourceArrayKey]);
    NSParameterAssert([self.dataSourceDict objectForKey:kPopularUsersDataSourceArrayKey]);
    NSParameterAssert([self.dataSourceDict objectForKey:kPopularReposDataSourceArrayKey]);
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if (exploreRowType == MGExploreRowForTrendRepos) {
        [parames setObject:@"Trend Repos This Week" forKey:kExploreRowViewModelTitleKey];
        [parames setObject:[self.dataSourceDict objectForKey:kTrendReposDataSourceArrayKey]
                    forKey:kExploreRowViewModelDataSourceKey];
        [parames setObject:@(MGExploreRowForTrendRepos) forKey:kExploreRowViewModelRowTypeKey];
        
    }else if(exploreRowType == MGExploreRowForPopularUsers) {
        [parames setObject:@"Popular Users" forKey:kExploreRowViewModelTitleKey];
        [parames setObject:[self.dataSourceDict objectForKey:kPopularUsersDataSourceArrayKey]
                    forKey:kExploreRowViewModelDataSourceKey];
        [parames setObject:@(MGExploreRowForPopularUsers) forKey:kExploreRowViewModelRowTypeKey];
        
    }else if(exploreRowType == MGExploreRowForPopularRepos) {
        [parames setObject:@"Popular Repos" forKey:kExploreRowViewModelTitleKey];
        [parames setObject:[self.dataSourceDict objectForKey:kPopularReposDataSourceArrayKey]
                    forKey:kExploreRowViewModelDataSourceKey];
        [parames setObject:@(MGExploreRowForPopularRepos) forKey:kExploreRowViewModelRowTypeKey];
    }
    MGExploreCellViewModel *rowViewModel = [[MGExploreCellViewModel alloc]initWithParams:parames];
    return rowViewModel;
}
@end
