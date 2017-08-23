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
#import "MGProfileViewModel.h"
#import "MGRepoDetailViewModel.h"

NSString *const kSearchText = @"kSearchText";


@interface MGSearchViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *searchUserCommand;

@property (nonatomic, strong, readwrite) RACCommand *searchRepoCommand;

@property (nonatomic, strong, readwrite) RACSignal *enabledSignal;

@property (nonatomic, assign, readwrite) CGRect tableViewFrame;

@property (nonatomic, strong, readwrite) NSMutableArray *searchUserResultData;

@property (nonatomic, strong, readwrite) NSMutableArray *searchRepoResultData;

@end



@implementation MGSearchViewModel

@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize page = _page;
@synthesize dataSource = _dataSource;

- (void)initialize{
    @weakify(self);
    self.searchUserResultData = [NSMutableArray array];
    self.searchRepoResultData = [NSMutableArray array];
    RACSignal *searchUserSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[[MGApiImpl sharedApiImpl] searchUserWithKeyWord:self.searchText
                                               reposLimit:0
                                           followersLimit:0
                                                 location:nil
                                                 language:nil
                                                 userType:MGSearchUserAllAccount
                                                 searchAt:MGSearchUserInDefault
                                                     sort:MGSearchUserSortWithDefault
                                                    order:MGSearchOrderWithDesc]
         subscribeNext:^(NSDictionary *dic) {
             MGSearchResultModel *result = [MGSearchResultModel mj_objectWithKeyValues:dic];
             [self.searchUserResultData removeAllObjects];
             NSArray *itemsArr = [[[result.items rac_sequence] map:^id(NSDictionary *value) {
                 return [MTLJSONAdapter modelOfClass:[OCTUser class]
                                  fromJSONDictionary:value error:nil];
             }] array];
             [self.searchUserResultData addObjectsFromArray:itemsArr];
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
                                                       starsLimit:0
                                                       topicLimit:0
                                                        forkLimit:0
                                                  forkIncluedType:MGSearchRepoForkIncluedYES
                                                             sort:MGSearchRepoSortWithStars
                                                            order:MGSearchOrderWithDesc] subscribeNext:^(NSDictionary *dic) {
            @strongify(self);
            MGSearchResultModel *result = [MGSearchResultModel mj_objectWithKeyValues:dic];
            [self.searchRepoResultData removeAllObjects];
            NSArray *itemsArr = [[[result.items rac_sequence] map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                 fromJSONDictionary:value error:nil];
            }] array];
            [self.searchRepoResultData addObjectsFromArray:itemsArr];
            [subscriber sendNext:RACTuplePack(@YES,@YES,itemsArr)];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
    self.enabledSignal = [[[RACObserve(self, searchText) ignore:NULL] distinctUntilChanged] map:^id(NSString *value) {
        NSLog(@"searchText --- %@",value);
        return value.length>=2?@YES:@NO;
    }];
    
    self.searchRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return searchRepoSignal;
    }];
    
    self.searchUserCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return searchUserSignal;
    }];
    
    
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        switch (self.searchType) {
            case MGSearchForUsers:{
                @strongify(self);
                OCTUser *user = self.searchUserResultData[(NSUInteger) indexPath.row];
                MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                               initWithParams:@{kProfileOfUserLoginName:user.login,
                                                                kProfileIsShowOnTabBar:@NO}];
                [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
            }
                break;
            case MGSearchForRepositories:{
                @strongify(self);
                MGRepositoriesModel *repo = self.searchRepoResultData[indexPath.row];
                MGRepoDetailViewModel *repoDetail =
                [[MGRepoDetailViewModel alloc]
                 initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,
                                  kRepoDetailParamsKeyForRepoName:repo.name}];
                [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
            }
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
}

#pragma mark - setter
- (void)setSearchType:(MGSearchType)searchType{
    if (_searchType==searchType) return;
    _searchType = searchType;
}
#pragma mark - getter
- (NSString *)searchLanguage{
    if (!_searchLanguage.isExist) {
        return [SAMKeychain mg_preferenceLanguage];
    }
    return _searchLanguage;
}
- (CGRect)tableViewFrame{
    return CGRectMake(0, 0,
                      MGSCREEN_WIDTH,
                      MGSCREEN_HEIGHT-
                      MGSEARCH_MENU_HEIGHT-
                      MGNAV_BAR_HEIGHT-
                      MGSTATUS_BAR_HEIGHT);
}
@end
