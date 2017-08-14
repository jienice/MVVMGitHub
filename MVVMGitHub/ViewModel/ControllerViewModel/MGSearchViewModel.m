//
//  MGSearchViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchViewModel.h"
#import "MGApiImpl+MGSearch.h"
#import "MGSearchResultModel.h"

NSString *const kSearchText = @"kSearchText";


@interface MGSearchViewModel ()

@end

@implementation MGSearchViewModel

- (void)initialize{
    
    @weakify(self);
    _searchUserResultData = [NSMutableArray array];
    _searchRepoResultData = [NSMutableArray array];
    RACSignal *searchUserSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[[MGApiImpl sharedApiImpl] searchUserWithKeyWord:self.searchText
                                               reposLimit:0 followersLimit:0
                                                 location:nil language:nil
                                                 userType:MGSearchUserAllAccount
                                                 searchAt:MGSearchUserInDefault
                                                     sort:MGSearchUserSortWithDefault
                                                    order:MGSearchOrderWithDesc]
         subscribeNext:^(NSDictionary *dic) {
             MGSearchResultModel *result = [MGSearchResultModel mj_objectWithKeyValues:dic];
             [_searchUserResultData removeAllObjects];
             NSArray *itemsArr = [[[result.items rac_sequence] map:^id(NSDictionary *value) {
                 return [MTLJSONAdapter modelOfClass:[OCTUser class]
                                  fromJSONDictionary:value error:nil];
             }] array];
             [_searchUserResultData addObjectsFromArray:itemsArr];
             [subscriber sendNext:RACTuplePack(@YES,@YES,itemsArr)];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
    RACSignal *searchRepoSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[[MGApiImpl sharedApiImpl] searchRepositoriesWithKeyWord:self.searchText
                                                         language:[SAMKeychain mg_preferenceLanguage]
                                                       starsLimit:0 topicLimit:0 forkLimit:0
                                                  forkIncluedType:MGSearchRepoForkIncluedYES
                                                             sort:MGSearchRepoSortWithStars
                                                            order:MGSearchOrderWithDesc] subscribeNext:^(NSDictionary *dic) {
            MGSearchResultModel *result = [MGSearchResultModel mj_objectWithKeyValues:dic];
            [_searchRepoResultData removeAllObjects];
            NSArray *itemsArr = [[[result.items rac_sequence] map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                 fromJSONDictionary:value error:nil];
            }] array];
            [_searchRepoResultData addObjectsFromArray:itemsArr];
            [subscriber sendNext:RACTuplePack(@YES,@YES,itemsArr)];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
    _enabledSignal = [[[RACObserve(self, searchText) ignore:NULL] distinctUntilChanged] map:^id(NSString *value) {
        NSLog(@"searchText --- %@",value);
        return value.length>=2?@YES:@NO;
    }];
    
    _searchRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return searchRepoSignal;
    }];
    
    _searchUserCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return searchUserSignal;
    }];
    
    _tableViewFrame = CGRectMake(0, 0,
                                 MGSCREEN_WIDTH,
                                 MGSCREEN_HEIGHT-
                                 MGTAB_BAR_HEIGHT-
                                 MGSEARCH_MENU_HEIGHT-
                                 MGNAV_BAR_HEIGHT-
                                 MGSTATUS_BAR_HEIGHT);
}
- (void)setSearchType:(MGSearchType)searchType{
    
    if (_searchType==searchType) return;
    _searchType = searchType;
}

- (NSString *)searchLanguage{
    
    if (!_searchLanguage.isExist) {
        return [SAMKeychain mg_preferenceLanguage];
    }
    return _searchLanguage;
}
@end
