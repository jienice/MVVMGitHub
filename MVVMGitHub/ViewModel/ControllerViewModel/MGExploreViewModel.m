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
#import "MGSearchViewModel.h"

#define EXPLORE_BASE_URL @"http://trending.codehub-app.com/v2/"

static NSString *kTrendReposThisWeek = @"Trend Repos This Week";
static NSString *kPopularUsers       = @"Popular Users";
static NSString *kPopularRepos = @"Popular Repos";


@interface MGExploreViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *requestTrendReposCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestPopularUsersCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestShowcasesCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestLanguageCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestPopularReposCommand;
@property (nonatomic, strong, readwrite) RACCommand *beginSearchCommand;
@property (nonatomic, strong, readwrite) NSArray *showCasesArray;

@end

@implementation MGExploreViewModel

@synthesize page                        = _page;
@synthesize dataSource                  = _dataSource;
@synthesize didSelectedRowCommand       = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (void)initialize{
    self.title = @"Explore";
    self.dataSource = [NSMutableArray array];
    @weakify(self);
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *fetchTrendRepoSignal = [self.requestTrendReposCommand execute:nil];
        RACSignal *fetchShowcasesSignal =  [self.requestShowcasesCommand execute:nil];
        RACSignal *fetchPopularUsersSignal =  [self.requestPopularUsersCommand execute:nil];
        RACSignal *fetchPopularReposSignal =  [self.requestPopularReposCommand execute:nil];
        return  [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[RACSignal zip:@[fetchTrendRepoSignal,fetchPopularUsersSignal,
                              fetchPopularReposSignal,fetchShowcasesSignal] reduce:^id(MGExploreCellViewModel *trendRepo,
                                                                                       MGExploreCellViewModel *popularUsers,
                                                                                       MGExploreCellViewModel *popularRepos,
                                                                                       NSArray *showcase){
                                  @strongify(self)
                                  self.showCasesArray = showcase;
                                  [self.dataSource addObject:trendRepo];
                                  [self.dataSource addObject:popularRepos];
                                  [self.dataSource addObject:popularUsers];
                                  return RACTuplePack(@YES,@YES,self.dataSource);
                             }] subscribeNext:^(RACTuple *tuple) {
                                 [subscriber sendNext:tuple];
                                 [subscriber sendCompleted];
                             }];
            @strongify(self)
            [[RACSignal combineLatest:@[self.requestTrendReposCommand.errors,
                                        self.requestShowcasesCommand.errors,
                                        self.requestPopularUsersCommand.errors,
                                        self.requestPopularReposCommand.errors] reduce:^NSError *(NSError *trendReposError,
                                                                                                  NSError *showcasesError,
                                                                                                  NSError *popularUsersError,
                                                                                                  NSError *popularReposError){
                                           return kNetWorkRequestError(9999, @"Fetch Data Fail.");
                                       }] subscribeNext:^(NSError *error) {
                                           [subscriber sendError:error];
                                       }];
            return nil;
        }] deliverOn:RACScheduler.mainThreadScheduler];
    }];
}


#pragma mark - lazy load
- (RACCommand *)requestPopularReposCommand {
	if(_requestPopularReposCommand == nil) {
        _requestPopularReposCommand =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[[[[MGApiImpl sharedApiImpl] searchRepositoriesWithKeyWord:nil
                                                                       language:@"objective-c"
                                                                           sort:@"stars"
                                                                          order:@"desc"]
                      map:^id(NSDictionary *dict) {
                NSArray *popularRepo = [[[[dict valueForKey:@"items"] rac_sequence] map:^id(NSDictionary *repoDic) {
                    return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class] fromJSONDictionary:repoDic error:nil];
                }] array];
                NSDictionary *responseDic = @{kMGExploreCellDataKey:popularRepo,
                                              kMGExploreCellTitleKey:kPopularRepos,
                                              kMGExploreCellTypeKey:@(MGExploreCellTypeOfRepo)};
                MGExploreCellViewModel *cellViewModel = [[MGExploreCellViewModel alloc]initWithParams:responseDic];
                return cellViewModel;
            }] retry:2] takeUntil:self.rac_willDeallocSignal];
        }];
    }
	return _requestPopularReposCommand;
}

- (RACCommand *)requestPopularUsersCommand {
	if(_requestPopularUsersCommand == nil) {
        _requestPopularUsersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
            return [[[[[MGApiImpl sharedApiImpl] searchPopularUsersWithLanguage:[SAMKeychain mg_preferenceLanguage]]
                      map:^id(NSDictionary *dict) {
                NSArray *popularUsers = [[[[dict valueForKey:@"items"] rac_sequence] map:^id(NSDictionary *usersDic) {
                    return  [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:usersDic error:nil];
                }] array];
                NSDictionary *responseDic = @{kMGExploreCellDataKey:popularUsers,
                                              kMGExploreCellTitleKey:kPopularUsers,
                                              kMGExploreCellTypeKey:@(MGExploreCellTypeOfUser)};
                MGExploreCellViewModel *cellViewModel = [[MGExploreCellViewModel alloc]initWithParams:responseDic];
                return cellViewModel;
            }]retry:2] takeUntil:self.rac_willDeallocSignal];
        }];	}
	return _requestPopularUsersCommand;
}

- (RACCommand *)requestTrendReposCommand {
	if(_requestTrendReposCommand == nil) {
        NSURL *baseUrl = [NSURL URLWithString:EXPLORE_BASE_URL];
        MGApiImpl *apiImpl = [[MGApiImpl alloc]initWithBaseUrl:baseUrl];
        _requestTrendReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
            return [[[[apiImpl fetchTrendReposSince:@"weekly" language:@"objective-c"]
                      map:^id(NSArray *dataArr) {
                NSArray *trending = [[[dataArr rac_sequence] map:^id(NSDictionary *repoDic) {
                    return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class] fromJSONDictionary:repoDic error:nil];
                }] array];
                NSDictionary *responseDic = @{kMGExploreCellDataKey:trending,
                                              kMGExploreCellTitleKey:kTrendReposThisWeek,
                                              kMGExploreCellTypeKey:@(MGExploreCellTypeOfRepo)};
                MGExploreCellViewModel *cellViewModel = [[MGExploreCellViewModel alloc]initWithParams:responseDic];
                return cellViewModel;
            }]retry:2] takeUntil:self.rac_willDeallocSignal];
        }];
	}
	return _requestTrendReposCommand;
}

- (RACCommand *)requestShowcasesCommand {
    if(_requestShowcasesCommand == nil) {
        NSURL *baseUrl = [NSURL URLWithString:EXPLORE_BASE_URL];
        MGApiImpl *apiImpl = [[MGApiImpl alloc]initWithBaseUrl:baseUrl];
        _requestShowcasesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[[apiImpl fetchShowcases] retry:2] takeUntil:self.rac_willDeallocSignal]
                 subscribeNext:^(NSArray *dataArr) {
                     NSArray *showcases = [MGShowcasesModel mj_objectArrayWithKeyValuesArray:dataArr];
                     [subscriber sendNext:showcases];
                 } error:^(NSError *error) {
                     [subscriber sendError:error];
                 } completed:^{
                     [subscriber sendCompleted];
                 }];
                return nil;
            }];
        }];
    }
    return _requestShowcasesCommand;
}

- (RACCommand *)requestLanguageCommand {
    if(_requestLanguageCommand == nil) {
        _requestLanguageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MGSearchViewModel *searchViewModel = [[MGSearchViewModel alloc]initWithParams:nil];
            [MGSharedDelegate.viewModelBased presentViewModel:searchViewModel animated:YES];
            return [RACSignal empty];
        }];
    }
    return _requestLanguageCommand;
}
- (RACCommand *)beginSearchCommand {
	if(_beginSearchCommand == nil) {
		_beginSearchCommand = [[RACCommand alloc] init];
	}
	return _beginSearchCommand;
}

@end
