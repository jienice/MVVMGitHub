//
//  MGUserViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@class MGUser;



@interface MGProfileViewModel : MGViewModel


@property (nonatomic, strong, readonly) RACCommand *fetchFeedsCommand;

@property (nonatomic, strong, readonly) RACCommand *fetchUserInfoCommand;

@property (nonatomic, strong, readonly) RACCommand *fetchUserOrgCommand;

@property (nonatomic, strong, readonly) RACCommand *fetchNotificationsCommand;

@property (nonatomic, strong, readonly) MGUser *user;

@property (nonatomic, strong, readonly) RACCommand *markNotificationAsReadCommand;

@property (nonatomic, strong, readonly) RACCommand *muteNotificationCommand;

@property (nonatomic, strong, readonly) NSMutableArray *notificationsArray;

@property (nonatomic, strong, readonly) NSMutableArray *orgArray;

@property (nonatomic, copy, readonly) NSString *loginName;


@end
