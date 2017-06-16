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


- (RACSignal *)searchUserWithKeyWord:(NSString *)keyWord
                            language:(NSString *)language
                                sort:(NSString *)sort
                               order:(NSString *)order{
    
    keyWord = [keyWord isExist]?[NSString stringWithFormat:@"%@+",keyWord]:@"";
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:@"/search/users"
                                            params:@{@"q":[NSString stringWithFormat:@"%@language:%@",keyWord,language],
                                                     @"sort":sort?sort:@"",
                                                     @"order":order?order:@"desc"}];
}

@end