//
//  MGApiService+MGSearch.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiService+MGSearch.h"

@implementation MGApiService (MGSearch)


+ (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                        sort:(NSString *)sort
                                       order:(NSString *)order{
    
    keyWord = [keyWord isExist]?[NSString stringWithFormat:@"%@+",keyWord]:@"";
    return [MGApiService starNetWorkRequestWithHttpMethod:GET
                                                  baseUrl:MGSharedDelegate.client.baseURL
                                                     path:@"/search/repositories"
                                                   params:@{@"q":[NSString stringWithFormat:@"%@language:%@",keyWord,language],
                                                            @"sort":@"stars",
                                                            @"order":@"desc"}];
}


+ (RACSignal *)searchUserWithKeyWord:(NSString *)keyWord
                            language:(NSString *)language
                                sort:(NSString *)sort
                               order:(NSString *)order{
    
    keyWord = [keyWord isExist]?[NSString stringWithFormat:@"%@+",keyWord]:@"";
    return [MGApiService starNetWorkRequestWithHttpMethod:GET
                                                  baseUrl:MGSharedDelegate.client.baseURL
                                                     path:@"/search/users"
                                                   params:@{@"q":[NSString stringWithFormat:@"%@language:%@",keyWord,language],
                                                            @"sort":sort,
                                                            @"order":order}];
}



@end
