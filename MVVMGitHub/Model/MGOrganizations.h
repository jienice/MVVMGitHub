//
//  MGOrganizations.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGOrganizations : OCTObject

@property (nonatomic, strong) NSURL *publicMembersURL;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *eventsURL;
@property (nonatomic, strong) NSURL *membersURL;
@property (nonatomic, strong) NSURL *issuesURL;
@property (nonatomic, strong) NSURL *reposURL;
@property (nonatomic, strong) NSURL *hooksURL;
@property (nonatomic, strong) NSURL *avatarURL;

@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *desc;


@end
