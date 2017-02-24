//
//  MGTrendRepoModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/18.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGRepositoriesModel : OCTRepository

@property (nonatomic, copy) NSString *keys_url;
@property (nonatomic, copy) NSString *statuses_url;
@property (nonatomic, copy) NSString *issue_events_url;
@property (nonatomic, copy) NSString *events_url;
@property (nonatomic, copy) NSString *subscription_url;
@property (nonatomic, copy) NSString *git_commits_url;
@property (nonatomic, copy) NSString *subscribers_url;
@property (nonatomic, copy) NSString *clone_url;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pulls_url;
@property (nonatomic, copy) NSString *notifications_url;
@property (nonatomic, copy) NSString *collaborators_url;
@property (nonatomic, copy) NSString *deployments_url;
@property (nonatomic, copy) NSString *languages_url;
@property (nonatomic, copy) NSString *comments_url;
@property (nonatomic, copy) NSString *git_tags_url;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *contents_url;
@property (nonatomic, copy) NSString *archive_url;
@property (nonatomic, copy) NSString *milestones_url;
@property (nonatomic, copy) NSString *blobs_url;
@property (nonatomic, copy) NSString *contributors_url;
@property (nonatomic, copy) NSString *trees_url;
@property (nonatomic, copy) NSString *svn_url;
@property (nonatomic, copy) NSString *commits_url;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *forks_url;
@property (nonatomic, copy) NSString *teams_url;
@property (nonatomic, copy) NSString *branches_url;
@property (nonatomic, copy) NSString *issue_comment_url;
@property (nonatomic, copy) NSString *merges_url;
@property (nonatomic, copy) NSString *git_refs_url;
@property (nonatomic, copy) NSString *hooks_url;
@property (nonatomic, copy) NSString *stargazers_url;
@property (nonatomic, copy) NSString *assignees_url;
@property (nonatomic, copy) NSString *compare_url;
@property (nonatomic, copy) NSString *full_name;
@property (nonatomic, copy) NSString *tags_url;
@property (nonatomic, copy) NSString *releases_url;
@property (nonatomic, copy) NSString *labels_url;
@property (nonatomic, copy) NSString *downloads_url;
@property (nonatomic, copy) NSString *language;

@property (nonatomic, strong) NSNumber *subscribers_count;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *has_issues;
@property (nonatomic, strong) NSNumber *has_wiki;
@property (nonatomic, strong) NSNumber *watchers;
@property (nonatomic, strong) NSNumber *network_count;
@property (nonatomic, strong) NSNumber *has_downloads;
@property (nonatomic, strong) NSNumber *open_issues_count;
@property (nonatomic, strong) NSNumber *forks_count;
@property (nonatomic, strong) NSNumber *stargazers_count;
@property (nonatomic, strong) NSNumber *watchers_count;
@property (nonatomic, strong) NSNumber *has_pages;
@property (nonatomic, strong) NSNumber *forks;
@property (nonatomic, strong) NSNumber *open_issues;

@property (nonatomic, strong) OCTUser *owner;

@end
