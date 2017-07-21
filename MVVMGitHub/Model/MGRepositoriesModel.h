//
//  MGTrendRepoModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/18.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGRepositoriesModel : OCTRepository

@property (nonatomic, strong) NSURL *keysURL;
@property (nonatomic, strong) NSURL *statusesURL;
@property (nonatomic, strong) NSURL *issueEventsURL;
@property (nonatomic, strong) NSURL *eventsURL;
@property (nonatomic, strong) NSURL *subscriptionURL;
@property (nonatomic, strong) NSURL *gitCommitsURL;
@property (nonatomic, strong) NSURL *subscribersURL;
@property (nonatomic, strong) NSURL *cloneURL;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *pullsURL;
@property (nonatomic, strong) NSURL *notificationsURL;
@property (nonatomic, strong) NSURL *collaboratorsURL;
@property (nonatomic, strong) NSURL *deploymentsURL;
@property (nonatomic, strong) NSURL *languagesURL;
@property (nonatomic, strong) NSURL *commentsURL;
@property (nonatomic, strong) NSURL *gitTagsURL;
@property (nonatomic, strong) NSURL *contentsURL;
@property (nonatomic, strong) NSURL *archiveURL;
@property (nonatomic, strong) NSURL *milestonesURL;
@property (nonatomic, strong) NSURL *blobsURL;
@property (nonatomic, strong) NSURL *contributorsURL;
@property (nonatomic, strong) NSURL *treesURL;
@property (nonatomic, strong) NSURL *svnURL;
@property (nonatomic, strong) NSURL *commitsURL;
@property (nonatomic, strong) NSURL *forksURL;
@property (nonatomic, strong) NSURL *teamsURL;
@property (nonatomic, strong) NSURL *branchesURL;
@property (nonatomic, strong) NSURL *issueCommentURL;
@property (nonatomic, strong) NSURL *mergesURL;
@property (nonatomic, strong) NSURL *gitRefsURL;
@property (nonatomic, strong) NSURL *hooksURL;
@property (nonatomic, strong) NSURL *stargazersURL;
@property (nonatomic, strong) NSURL *assigneesURL;
@property (nonatomic, strong) NSURL *compareURL;
@property (nonatomic, strong) NSURL *tagsURL;
@property (nonatomic, strong) NSURL *releasesURL;
@property (nonatomic, strong) NSURL *labelsURL;
@property (nonatomic, strong) NSURL *downloadsURL;

@property (nonatomic, strong)NSDate *updatedDate;
@property (nonatomic, strong)NSDate *createdDate;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *language;


@property (nonatomic, strong) NSNumber *subscribersCount;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *networkCount;
@property (nonatomic, strong) NSNumber *openIssuesCount;
@property (nonatomic, strong) NSNumber *forksCount;
@property (nonatomic, strong) NSNumber *stargazersCount;
@property (nonatomic, strong) NSNumber *watchersCount;

@property (nonatomic, strong) NSNumber *hasPages;
@property (nonatomic, strong) NSNumber *hasDownloads;
@property (nonatomic, strong) NSNumber *hasIssues;
@property (nonatomic, strong) NSNumber *hasWiki;
@property (nonatomic, strong) OCTUser *owner;

@end
