//
//  MGApiService+MGExplore.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiService+MGExplore.h"

#define EXPLORE_BASE_URL @"http://trending.codehub-app.com/v2/"

@implementation MGApiService (MGExplore)

- (RACSignal *)fetchTrendReposSince:(NSString *)since language:(NSString *)language{
    
    NSParameterAssert([since isExist]);
    return [self starNetWorkRequestWithHttpMethod:GET
                                          baseUrl:[NSURL URLWithString:EXPLORE_BASE_URL]
                                             path:@"trending"
                                           params:@{@"since":since,
                                                    @"language":language}];
}

- (RACSignal *)fetchShowcases{
    
   return  [self starNetWorkRequestWithHttpMethod:GET
                                          baseUrl:[NSURL URLWithString:EXPLORE_BASE_URL]
                                             path:@"showcases"
                                           params:nil];
    
}

@end
