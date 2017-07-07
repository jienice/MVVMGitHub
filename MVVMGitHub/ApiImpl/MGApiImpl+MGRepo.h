//
//  MGApiImpl+MGRepo.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

typedef NS_ENUM(NSInteger,MGRepoType){
    MGRepoTypeDefault,//owner
    MGRepoTypeBelongToUser,//owner
    MGRepoTypeOwnersContainUser,//member
    MGRepoTypeAll//owner、member
};

@interface MGApiImpl (MGRepo)

- (RACSignal *)fetchRepoDetailWithOwner:(NSString *)ower repoName:(NSString *)repoName;

- (RACSignal *)fetchRepoListWithOwnerName:(NSString *)ower repoType:(MGRepoType)repoType;


@end
