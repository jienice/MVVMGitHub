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
 */

@interface MGApiImpl (MGSearch)

//stars, forks, or updated. Default: results are sorted by best match.
//asc or desc. Default: desc

- (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                        sort:(NSString *)sort
                                       order:(NSString *)order;


- (RACSignal *)searchUserWithKeyWord:(NSString *)keyWord
                            language:(NSString *)language
                                sort:(NSString *)sort
                               order:(NSString *)order;

@end
