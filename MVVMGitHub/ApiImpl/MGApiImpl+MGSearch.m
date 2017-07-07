//
//  MGApiImpl+MGSearch.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl+MGSearch.h"

@implementation MGApiImpl (MGSearch)
- (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                        sort:(NSString *)sort
                                       order:(NSString *)order{
    
    keyWord = [keyWord isExist]?[NSString stringWithFormat:@"%@+",keyWord]:@"";
    return  [self startNetWorkRequestWithHttpMethod:GET
                                               path:@"/search/repositories"
                                             params:@{@"q":[NSString stringWithFormat:@"%@language:%@",keyWord,language],
                                                      @"sort":sort?sort:@"",
                                                      @"order":order?order:@"desc"}];
    }
- (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                  starsLimit:(NSInteger)starsLimit
                                  topicLimit:(NSInteger)topicLimit
                                   forkLimit:(NSInteger)forkLimit
                             forkIncluedType:(MGSearchRepoForkIncluedType)forkIncluedType
                                        sort:(MGSearchRepoSortType)sortType
                                       order:(MGSearchOrderType)orderType{
    
    NSString *forkIncluedTypeString,*sortString,*orderString = [NSString string];
    switch (forkIncluedType) {
        case MGSearchRepoForkIncluedNO:
            forkIncluedTypeString = @"false";
            break;
        case MGSearchRepoForkIncluedYES:
            forkIncluedTypeString = @"true";
            break;
        case MGSearchRepoForkIncluedOnly:
            forkIncluedTypeString = @"only";
            break;
        default:
            break;
    }
    
    switch (sortType) {
        case MGSearchRepoSortWithForks:
            sortString = @"forks";
            break;
        case MGSearchRepoSortWithStars:
            sortString = @"stars";
            break;
        case MGSearchRepoSortWithUpdated:
            sortString = @"updated";
            break;
        case MGSearchRepoSortWithDefault:
            sortString = nil;
            break;
        default:
            break;
    }
    switch (orderType) {
        case MGSearchOrderWithAsc:
            orderString = @"asc";
            break;
        case MGSearchOrderWithDesc:
            orderString = @"desc";
            break;
        default:
            break;
    }
    NSMutableString *qString = [NSMutableString string];
    if (keyWord.isExist) {
        [qString appendFormat:@"%@+",[keyWord lowercaseString]];
    }
    if (forkIncluedTypeString.isExist){
        [qString appendFormat:@"fork:%@+",forkIncluedTypeString];
    }
    if (language.isExist) {
        [qString appendFormat:@"language:%@+",language];
    }
    if (starsLimit) {
        [qString appendFormat:@"stars:>%ld+",starsLimit];
    }
    if (topicLimit) {
        [qString appendFormat:@"topics:>%ld+",topicLimit];
    }
    if (forkLimit) {
        [qString appendFormat:@"forks:>%ld+",forkLimit];
    }
    //remove last '+'
    NSString *qStringForNetWork = [qString substringWithRange:NSMakeRange(0, qString.length-1)];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:@"/search/repositories"
                                            params:@{@"q":qStringForNetWork,
                                                     @"sort":sortString.isExist?sortString:@"",
                                                     @"order":orderString.isExist?orderString:@"desc"}];
}

- (RACSignal *)searchPopularUsersWithLanguage:(NSString *)language{
    
    return [self searchUserWithKeyWord:nil reposLimit:0 followersLimit:0
                              location:nil
                              language:language
                              userType:MGSearchUserAllAccount
                              searchAt:MGSearchUserInDefault
                                  sort:MGSearchUserSortWithFollowers
                                 order:MGSearchOrderWithDesc];
}

- (RACSignal *)searchUserWithKeyWord:(NSString *)keyWord
                          reposLimit:(NSInteger)reposLimit
                      followersLimit:(NSInteger)followersLimit
                            location:(NSString *)location
                            language:(NSString *)language
                            userType:(MGSearchUserAccountType)userType
                            searchAt:(MGSearchUserRange)searchAt
                                sort:(MGSearchUserSortType)sortType
                               order:(MGSearchOrderType)orderType{
    
    NSString *userTypeString,*searchAtString,*sortString,*orderString = [NSString string];
    switch (userType) {
        case MGSearchUserPersonalAccount:
            userTypeString = @"users";
            break;
        case MGSearchUserOrganizationAccount:
            userTypeString = @"org";
            break;
        case MGSearchUserAllAccount:
            userTypeString = nil;
            break;
        default:
            break;
    }
    
    switch (searchAt) {
        case MGSearchUserInEmailRange:
            searchAtString = @"email";
            break;
        case MGSearchUserInFullNameRange:
            searchAtString = @"fullname";
            break;
        case MGSearchUserInUserNameRange:
            searchAtString = @"login";
            break;
        case MGSearchUserInDefault:
            searchAtString = nil;
            break;
        default:
            break;
    }
    switch (sortType) {
        case MGSearchUserSortWithJoined:
            sortString = @"joined";
            break;
        case MGSearchUserSortWithFollowers:
            sortString = @"followers";
            break;
        case MGSearchUserSortWithRepositories:
            sortString = @"repositories";
            break;
        case MGSearchUserSortWithDefault:
            sortString = nil;
            break;
        default:
            break;
    }
    switch (orderType) {
        case MGSearchOrderWithAsc:
            orderString = @"asc";
            break;
        case MGSearchOrderWithDesc:
            orderString = @"desc";
            break;
        default:
            break;
    }
    NSMutableString *qString = [NSMutableString string];
    if (keyWord.isExist) {
        [qString appendFormat:@"%@+",[keyWord lowercaseString]];
    }
    if (userTypeString.isExist) {
        [qString appendFormat:@"type:%@+",userTypeString];
    }
    if (searchAtString.isExist) {
        [qString appendFormat:@"in:%@+",searchAtString];
    }
    if (location.isExist){
        [qString appendFormat:@"location:%@+",location];
    }
    if (language.isExist) {
        [qString appendFormat:@"language:%@+",language];
    }
    if (reposLimit) {
        [qString appendFormat:@"repos:>%ld+",reposLimit];
    }
    if (followersLimit) {
        [qString appendFormat:@"followers:>%ld+",followersLimit];
    }
    //remove last '+'
    NSString *qStringForNetWork = [qString substringWithRange:NSMakeRange(0, qString.length-1)];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:@"/search/users"
                                            params:@{@"q":qStringForNetWork,
                                                     @"sort":sortString.isExist?sortString:@"",
                                                     @"order":orderString.isExist?orderString:@"desc",
                                                     @"page":@1,
                                                     @"per_page":@10}];
}

@end
