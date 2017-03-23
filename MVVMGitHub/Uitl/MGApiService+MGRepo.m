//
//  MGApiService+MGRepo.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiService+MGRepo.h"

@implementation MGApiService (MGRepo)

- (RACSignal *)fetchRepoDetaiWithOwner:(NSString *)ower repoName:(NSString *)repoName{
    
    NSParameterAssert([ower isExist]);
    NSParameterAssert([repoName isExist]);
    return [self starNetWorkRequestWithHttpMethod:GET
                                          baseUrl:MGSharedDelegate.client.baseURL
                                             path:[NSString stringWithFormat:@"repos/%@/%@",ower,repoName]
                                           params:nil];
}



@end
