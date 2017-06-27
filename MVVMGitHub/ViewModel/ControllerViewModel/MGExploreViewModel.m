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
#import "MGApiImpl+MGExplore.h"
#import "MGApiImpl+MGSearch.h"

#define EXPLORE_BASE_URL @"http://trending.codehub-app.com/v2/"

NSString *const kTrendReposDataSourceArrayKey   = @"kTrendReposDataSourceArrayKey";
NSString *const kShowcasesDataSourceArrayKey    = @"kShowcasesDataSourceArrayKey";
NSString *const kPopularUsersDataSourceArrayKey = @"kPopularUsersDataSourceArrayKey";
NSString *const kPopularReposDataSourceArrayKey = @"kPopularReposDataSourceArrayKey";

static NSString *kTrendReposThisWeek = @"Trend Repos This Week";
static NSString *kPopularUsers       = @"Popular Users";
static NSString *kPopularRepos = @"Popular Repos";


@interface MGExploreViewModel ()


@end

@implementation MGExploreViewModel

@synthesize page                        = _page;
@synthesize dataSource                  = _dataSource;
@synthesize didSelectedRowCommand       = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (void)initialize{
    
    self.title = @"Explore";
    _dataSource                = [NSMutableArray array];
    RACSubject *popularUsersSB = [RACSubject subject];
    RACSubject *trendReposSB   = [RACSubject subject];
    RACSubject *popularReposSB = [RACSubject subject];
    
    @weakify(self);
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.requestTrendReposCommand execute:nil];
        [self.requestShowcasesCommand execute:nil];
        [self.requestPopularUsersCommand execute:nil];
        [self.requestPopularReposCommand execute:nil];
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[RACSignal zip:@[popularUsersSB,trendReposSB,popularReposSB]] subscribeNext:^(RACTuple *tuple) {
                NSNumber *popularUsers = [tuple second];
                NSNumber *trendRepos   = [tuple third];
                NSNumber *popularRepos = [tuple last];
                if ([popularRepos boolValue]&&
                    [trendRepos boolValue]&&
                    [popularUsers boolValue]) {
                    [subscriber sendNext:RACTuplePack(@YES,@YES,_dataSource)];
                    [subscriber sendCompleted];
                }else{
                    [subscriber sendError:kNetWorkRequestError(9999, @"Fetch Data Fail.")];
                }
            }];
            return nil;
        }] deliverOn:RACScheduler.mainThreadScheduler];
    }];
    
    NSURL *baseUrl = [NSURL URLWithString:EXPLORE_BASE_URL];
    MGApiImpl *apiImpl = [[MGApiImpl alloc]initWithBaseUrl:baseUrl];
    _requestShowcasesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[[[apiImpl fetchShowcases] retry:2] takeUntil:self.rac_willDeallocSignal]
             subscribeNext:^(NSArray *dataArr) {
                 NSArray *showcases = [MGShowcasesModel mj_objectArrayWithKeyValuesArray:dataArr];
                 [subscriber sendNext:showcases];
                 [subscriber sendCompleted];
             } error:^(NSError *error) {
                 [subscriber sendError:error];
             }];
            return nil;
        }];
    }];
    _requestTrendReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        return [[[[[apiImpl fetchTrendReposSince:@"weekly"
                                        language:@"objective-c"] retry:2]
                  takeUntil:self.rac_willDeallocSignal] doNext:^(NSArray *dataArr) {
            @strongify(self);
            NSArray *trending = [[[dataArr rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class] fromJSONDictionary:repoDic error:nil];
            }] array];
            NSDictionary *responseDic = [NSDictionary dictionaryWithObject:trending
                                                                    forKey:kTrendReposDataSourceArrayKey];
            [self confirmDataSourceOnlyHaveOneGivenTitleCellViewMolde:kTrendReposThisWeek];
            [_dataSource addObject:[self responseToCellViewModel:responseDic]];
            [trendReposSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [trendReposSB sendNext:@NO];
        }];
    }];
    
    _requestPopularUsersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        return [[[[[[MGApiImpl sharedApiImpl]
                    searchPopularUsersWithLanguage:[SAMKeychain mg_preferenceLanguage]] retry:2]
                  takeUntil:self.rac_willDeallocSignal] doNext:^(NSDictionary *dict) {
            @strongify(self);
            NSArray *popularUsers = [[[[dict valueForKey:@"items"] rac_sequence] map:^id(NSDictionary *usersDic) {
                return  [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:usersDic error:nil];
            }] array];
            NSDictionary *responseDic = [NSDictionary dictionaryWithObject:popularUsers
                                                                    forKey:kPopularUsersDataSourceArrayKey];
            [self confirmDataSourceOnlyHaveOneGivenTitleCellViewMolde:kPopularUsers];
            [_dataSource addObject:[self responseToCellViewModel:responseDic]];
            [popularUsersSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [popularUsersSB sendNext:@NO];
        }];
    }];
    
    
    _requestPopularReposCommand =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[[[[MGApiImpl sharedApiImpl] searchRepositoriesWithKeyWord:nil
                                                                   language:@"objective-c"
                                                                       sort:@"stars"
                                                                      order:@"desc"] retry:2]
                  takeUntil:self.rac_willDeallocSignal] doNext:^(NSDictionary *dict) {
            @strongify(self);
            NSArray *popularRepo = [[[[dict valueForKey:@"items"] rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class] fromJSONDictionary:repoDic error:nil];
            }] array];
            NSDictionary *responseDic = [NSDictionary dictionaryWithObject:popularRepo
                                                                    forKey:kPopularReposDataSourceArrayKey];
            [self confirmDataSourceOnlyHaveOneGivenTitleCellViewMolde:kPopularRepos];
            [_dataSource addObject:[self responseToCellViewModel:responseDic]];
            [popularReposSB sendNext:@YES];
        }] doError:^(NSError *error) {
            [popularReposSB sendNext:@NO];
        }];
    }];
}

- (MGExploreCellViewModel *)responseToCellViewModel:(NSDictionary *)respon{
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if ([respon.allKeys.firstObject isEqualToString:kTrendReposDataSourceArrayKey]) {
        [parames setObject:kTrendReposThisWeek forKey:kMGExploreCellTitleKey];
        [parames setObject:@(MGExploreCellTypeOfRepo) forKey:kMGExploreCellTypeKey];
    }else if([respon.allKeys.firstObject isEqualToString:kPopularUsersDataSourceArrayKey]) {
        [parames setObject:kPopularUsers forKey:kMGExploreCellTitleKey];
        [parames setObject:@(MGExploreCellTypeOfUser) forKey:kMGExploreCellTypeKey];
    }else if([respon.allKeys.firstObject isEqualToString:kPopularReposDataSourceArrayKey]) {
        [parames setObject:kPopularRepos forKey:kMGExploreCellTitleKey];
        [parames setObject:@(MGExploreCellTypeOfRepo) forKey:kMGExploreCellTypeKey];
    }
    [parames setObject:[respon objectForKey:respon.allKeys.firstObject] forKey:kMGExploreCellDataKey];
    MGExploreCellViewModel *cellViewModel = [[MGExploreCellViewModel alloc]initWithParams:parames];
    return cellViewModel;
}

- (void)confirmDataSourceOnlyHaveOneGivenTitleCellViewMolde:(NSString *)givenTitle{
    
    for (MGExploreCellViewModel *cellViewModel in _dataSource) {
        if ([cellViewModel.cellTitle isEqualToString:givenTitle]) {
            [_dataSource removeObject:cellViewModel];
            return;
        }
    }
}
@end
