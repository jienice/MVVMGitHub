//
//  MGEvent.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/10.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGRepositoriesModel.h"
#import "MGUser.h"

@interface MGActor : OCTObject

@property (nonatomic, copy) NSString *displayLogin;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *gravatarID;


@end

@interface MGOrg : OCTObject

@property (nonatomic, copy) NSString *login;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *gravatarID;


@end

@interface MGPullRequest : OCTObject

@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;

@property (nonatomic, strong) NSURL *patchURL;
@property (nonatomic, strong) NSURL *htmlURL;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *commentsURL;
@property (nonatomic, strong) NSURL *reviewCommentURL;
@property (nonatomic, strong) NSURL *issueURL;
@property (nonatomic, strong) NSURL *diffURL;
@property (nonatomic, strong) NSURL *commitsURL;
@property (nonatomic, strong) NSURL *statusesURL;
@property (nonatomic, strong) NSURL *reviewCommentsURL;

@property (nonatomic, copy) NSString *mergeableState;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *body;

@property (nonatomic, strong) NSNumber *merged;
@property (nonatomic, strong) NSNumber *changedFiles;
@property (nonatomic, strong) NSNumber *deletions;
@property (nonatomic, strong) NSNumber *maintainerCanModify;
@property (nonatomic, strong) NSNumber *reviewComments;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSNumber *commits;
@property (nonatomic, strong) NSNumber *locked;
@property (nonatomic, strong) NSNumber *comments;
@property (nonatomic, strong) NSNumber *additions;

@property (nonatomic, strong) MGUser *user;

@property (nonatomic, strong) NSDictionary *head;
@property (nonatomic, strong) NSDictionary *base;
@property (nonatomic, strong) NSDictionary *_links;


@end

@interface MGPayload : OCTObject

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *masterBranch;
@property (nonatomic, copy) NSString *pusherType;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *refType;
@property (nonatomic, copy) NSString *ref;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) MGPullRequest *pullRequest;


@end

@interface MGEvent : OCTObject

@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *isPublic;
@property (nonatomic, strong) MGActor *actor;
@property (nonatomic, strong) MGRepositoriesModel *repo;
@property (nonatomic, strong) MGOrg *org;
@property (nonatomic, strong) MGPayload *payload;

@end


