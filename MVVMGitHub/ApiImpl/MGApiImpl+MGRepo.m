//
//  MGApiImpl+MGRepo.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl+MGRepo.h"

@implementation MGApiImpl (MGRepo)
- (RACSignal *)fetchRepoDetailWithOwner:(NSString *)ower repoName:(NSString *)repoName{
    
    NSParameterAssert([ower isExist]);
    NSParameterAssert([repoName isExist]);
    NSString *path = [NSString stringWithFormat:@"repos/%@/%@",ower,repoName];
    return [self startNetWorkRequestWithHttpMethod:GET path:path params:nil];
}



- (RACSignal *)fetchRepoListWithOwnerName:(NSString *)ower repoType:(MGRepoType)repoType{
    
    NSParameterAssert([ower isExist]);
    NSString *type = [NSString string];
    switch (repoType) {//all, owner, member
        case MGRepoTypeDefault:{
            type = @"owner";
        }
            break;
        case MGRepoTypeAll:{
            type = @"all";
        }
            break;
        case MGRepoTypeBelongToUser:{
            type = @"owner";
        }
            break;
        case MGRepoTypeOwnersContainUser:{
            type = @"member";
        }
            break;
        default:
            break;
    }
    NSString *path = [NSString stringWithFormat:@"users/%@/repos",ower];
    return [self startNetWorkRequestWithHttpMethod:GET path:path params:@{@"type":type}];}

@end
