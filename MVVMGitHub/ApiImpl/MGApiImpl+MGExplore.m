//
//  MGApiImpl+MGExplore.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl+MGExplore.h"

@implementation MGApiImpl (MGExplore)

- (RACSignal *)fetchTrendReposSince:(NSString *)since language:(NSString *)language{
    
    NSParameterAssert([since isExist]);
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:@"trending"
                                            params:@{@"since":since,
                                                     @"language":language}];
}

- (RACSignal *)fetchShowcases{
    
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:@"showcases" params:nil];
}


@end
