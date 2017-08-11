//
//  MGApiImpl+MGUser.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl+MGUser.h"

@implementation MGApiImpl (MGUser)

- (RACSignal *)fetchUserInfoWithLoginName:(NSString *)loginName{
    
    NSString *path=[NSString stringWithFormat:@"users/%@",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:nil];
}

- (RACSignal *)fetchUserFollowersListWithLoginName:(NSString *)loginName{
    
    NSString *path=[NSString stringWithFormat:@"users/%@/followers",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:nil];
}

- (RACSignal *)fetchUserFollowingListWithLoginName:(NSString *)loginName{
    
    NSString *path=[NSString stringWithFormat:@"users/%@/following",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:nil];
}

- (RACSignal *)fetchUserOrgListWithLoginName:(NSString *)loginName{
    
    NSString *path=[NSString stringWithFormat:@"users/%@/orgs",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:nil];
}

@end
