//
//  MGApiImpl+MGSearch.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

/**
 The Search API has a custom rate limit.
 For requests using Basic Authentication, OAuth, or client ID and secret, you can make up to 30 requests per minute.
 For unauthenticated requests, the rate limit allows you to make up to 10 requests per minute.
 
 搜索语法文档：https://help.github.com/articles/searching-users/
 */

typedef NS_ENUM(NSInteger,MGSearchUserRange){
    MGSearchUserInDefault,
    MGSearchUserInUserNameRange,
    MGSearchUserInEmailRange,
    MGSearchUserInFullNameRange
};

typedef NS_ENUM(NSInteger,MGSearchUserAccountType){
    MGSearchUserAllAccount,
    MGSearchUserPersonalAccount,
    MGSearchUserOrganizationAccount
};
typedef NS_ENUM(NSInteger,MGSearchOrderType) {
    MGSearchOrderWithDesc,
    MGSearchOrderWithAsc
};

typedef NS_ENUM(NSInteger,MGSearchUserSortType) {
    MGSearchUserSortWithDefault,
    MGSearchUserSortWithFollowers,
    MGSearchUserSortWithRepositories,
    MGSearchUserSortWithJoined
};
typedef NS_ENUM(NSInteger,MGSearchRepoSortType) {
    MGSearchRepoSortWithDefault,
    MGSearchRepoSortWithStars,
    MGSearchRepoSortWithForks,
    MGSearchRepoSortWithUpdated
};
typedef NS_ENUM(NSInteger,MGSearchRepoForkIncluedType) {
    MGSearchRepoForkIncluedYES,
    MGSearchRepoForkIncluedNO,
    MGSearchRepoForkIncluedOnly
};
@interface MGApiImpl (MGSearch)

//stars, forks, or updated. Default: results are sorted by best match.
//asc or desc. Default: desc

- (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                        sort:(NSString *)sort
                                       order:(NSString *)order;

- (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                  starsLimit:(NSInteger)starsLimit
                                  topicLimit:(NSInteger)topicLimit
                                   forkLimit:(NSInteger)forkLimit
                             forkIncluedType:(MGSearchRepoForkIncluedType)forkIncluedType
                                        sort:(MGSearchRepoSortType)sortType
                                       order:(MGSearchOrderType)orderType;



- (RACSignal *)searchUserWithKeyWord:(NSString *)keyWord
                          reposLimit:(NSInteger)reposLimit
                      followersLimit:(NSInteger)followersLimit
                            location:(NSString *)location
                            language:(NSString *)language
                            userType:(MGSearchUserAccountType)userType
                            searchAt:(MGSearchUserRange)searchAt
                                sort:(MGSearchUserSortType)sortType
                               order:(MGSearchOrderType)orderType;

- (RACSignal *)searchPopularUsersWithLanguage:(NSString *)language;


@end
