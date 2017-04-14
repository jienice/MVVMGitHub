//
//  MGApiImpl+MGRepo.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl+MGRepo.h"

@implementation MGApiImpl (MGRepo)
- (RACSignal *)fetchRepoDetaiWithOwner:(NSString *)ower repoName:(NSString *)repoName{
    
    NSParameterAssert([ower isExist]);
    NSParameterAssert([repoName isExist]);
    return [self starNetWorkRequestWithHttpMethod:GET
                                          baseUrl:MGSharedDelegate.client.baseURL
                                             path:[NSString stringWithFormat:@"repos/%@/%@",ower,repoName]
                                           params:nil];
}
@end
