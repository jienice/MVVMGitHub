//
//  MGUserViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@class MGUser;

extern NSString *const kProfileOfUserLoginName;


@interface MGProfileViewModel : MGViewModel


@property (nonatomic, strong, readonly) RACCommand *fetchFollowersCommand;

@property (nonatomic, strong, readonly) RACCommand *fetchFollowingUsersCommand;

@property (nonatomic, strong, readonly) RACCommand *fetchFeedsCommand;

@property (nonatomic, strong, readonly) RACCommand *fetchUserInfoCommand;

@property (nonatomic, strong, readonly) MGUser *user;

@end
