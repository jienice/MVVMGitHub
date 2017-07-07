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

- (RACSignal *)fetchUserFollowersListWithLoginName:(NSString *)loginName page:(NSInteger)page{
    
    NSString *path=[NSString stringWithFormat:@"users/%@/followers",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:page?nil:[self paramsWithPage:page]];
}

- (RACSignal *)fetchUserFollowingListWithLoginName:(NSString *)loginName page:(NSInteger)page{
    
    NSString *path=[NSString stringWithFormat:@"users/%@/following",loginName];
    return [self startNetWorkRequestWithHttpMethod:GET
                                              path:path
                                            params:page?nil:[self paramsWithPage:page]];
}
@end
