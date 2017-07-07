//
//  MGUser.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface MGUser : OCTUser

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *followingURL;
@property (nonatomic, strong) NSURL *eventsURL;
@property (nonatomic, strong) NSURL *receivedEventsURL;
@property (nonatomic, strong) NSURL *subscriptionsURL;
@property (nonatomic, strong) NSURL *gistsURL;
@property (nonatomic, strong) NSURL *starredURL;
@property (nonatomic, strong) NSURL *organizationsURL;
@property (nonatomic, strong) NSURL *reposURL;
@property (nonatomic, strong) NSURL *followersURL;
@property (nonatomic, strong) NSURL *htmlURL;

@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSDate *createdDate;

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *gravatar_id;

@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger publicGistsCount;
@property (nonatomic, strong) NSNumber *hireable;
@property (nonatomic, strong) NSNumber *site_admin;

@end
