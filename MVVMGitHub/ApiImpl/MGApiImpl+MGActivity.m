//
//  MGApiImpl+MGActivity.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/10.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl+MGActivity.h"

@implementation MGApiImpl (MGActivity)


- (RACSignal *)fetchUserPublicEventsWithLoginName:(NSString *)loginName{
    
    NSString *path = [NSString stringWithFormat:@"users/%@/events",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:nil];
}
@end
