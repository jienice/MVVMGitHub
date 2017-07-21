//
//  MGTrendRepoModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/18.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepositoriesModel.h"

@implementation MGRepositoriesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"keysURL":@"keys_url",
              @"statusesURL":@"statuses_url",
              @"issueEventsURL":@"issue_events_url",
              @"eventsURL":@"events_url",
              @"subscriptionURL":@"subscription_url",
              @"gitCommitsURL":@"git_commits_url",
              @"subscribersURL":@"subscribers_url",
              @"cloneURL":@"clone_url",
              @"URL":@"url",
              @"pullsURL":@"pulls_url",
              @"notificationsURL":@"notifications_url",
              @"collaboratorsURL":@"collaborators_url",
              @"deploymentsURL":@"deployments_url",
              @"languagesURL":@"languages_url",
              @"commentsURL":@"comments_url",
              @"gitTagsURL":@"git_tags_url",
              @"contentsURL":@"contents_url",
              @"archiveURL":@"archive_url",
              @"milestonesURL":@"milestones_url",
              @"blobsURL":@"blobs_url",
              @"contributorsURL":@"contributors_url",
              @"treesURL":@"trees_url",
              @"svnURL":@"svn_url",
              @"commitsURL":@"commits_url",
              @"forksURL":@"forks_url",
              @"teamsURL":@"teams_url",
              @"branchesURL":@"branches_url",
              @"issueCommentURL":@"issue_comment_url",
              @"mergesURL":@"merges_url",
              @"gitRefsURL":@"git_refs_url",
              @"hooksURL":@"hooks_url",
              @"stargazersURL":@"stargazers_url",
              @"assigneesURL":@"assignees_url",
              @"compareURL":@"compare_url",
              @"releasesURL":@"releases_url",
              @"labelsRUL":@"labels_url",
              @"downloadsURL":@"downloads_url",
              @"updatedDate":@"updated_at",
              @"createdDate":@"created_at",
              @"fullName":@"full_name",
              @"subscribersCount":@"subscribers_count",
              @"hasIssues":@"has_issues",
              @"hasWiki":@"has_wiki",
              @"networkCount":@"network_count",
              @"hasDownloads":@"has_downloads",
              @"openIssuesCount":@"open_issues_count",
              @"forksCount":@"forks_count",
              @"stargazersCount":@"stargazers_count",
              @"watchersCount":@"watchers_count",
              @"hasPages":@"has_pages"}];
}
+ (NSValueTransformer *)ownerJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:OCTUser.class];
}
+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+ (NSValueTransformer *)dateJSONTransformer {
    return [NSValueTransformer valueTransformerForName:OCTDateValueTransformerName];
}

#pragma mark Migration

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation
                                                            version:(NSUInteger)fromVersion {
    
    NSMutableDictionary *dictionaryValue = [[super dictionaryValueFromArchivedExternalRepresentation:externalRepresentation
                                                                                             version:fromVersion]
                                            mutableCopy];
    
    dictionaryValue[@"URL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"url"]] ?: NSNull.null;
    dictionaryValue[@"keysURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"keys_url"]] ?: NSNull.null;
    dictionaryValue[@"statusesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"statuses_url"]] ?: NSNull.null;
    dictionaryValue[@"issueEventsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"issue_events_url"]] ?: NSNull.null;
    dictionaryValue[@"eventsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"events_url"]] ?: NSNull.null;
    dictionaryValue[@"subscriptionURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"subscription_url"]] ?: NSNull.null;
    dictionaryValue[@"gitCommitsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"git_commits_url"]] ?: NSNull.null;
    dictionaryValue[@"subscribersURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"subscribers_url"]] ?: NSNull.null;
    dictionaryValue[@"cloneURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"clone_url"]] ?: NSNull.null;
    dictionaryValue[@"pullsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"pulls_url"]] ?: NSNull.null;
    dictionaryValue[@"notificationsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"notifications_url"]] ?: NSNull.null;
    dictionaryValue[@"collaboratorsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"collaborators_url"]] ?: NSNull.null;
    dictionaryValue[@"deploymentsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"deployments_url"]] ?: NSNull.null;
    dictionaryValue[@"languagesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"languages_url"]] ?: NSNull.null;
    dictionaryValue[@"commentsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"comments_url"]] ?: NSNull.null;
    dictionaryValue[@"gitTagsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"git_tags_url"]] ?: NSNull.null;
    dictionaryValue[@"contentsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"contents_url"]] ?: NSNull.null;
    dictionaryValue[@"archiveURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"archive_url"]] ?: NSNull.null;
    dictionaryValue[@"milestonesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"milestones_url"]] ?: NSNull.null;
    dictionaryValue[@"blobsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"blobs_url"]] ?: NSNull.null;
    dictionaryValue[@"contributorsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"contributors_url"]] ?: NSNull.null;
    dictionaryValue[@"treesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"trees_url"]] ?: NSNull.null;
    dictionaryValue[@"svnURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"svn_url"]] ?: NSNull.null;
    dictionaryValue[@"commitsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"commits_url"]] ?: NSNull.null;
    dictionaryValue[@"forksURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"forks_url"]] ?: NSNull.null;
    dictionaryValue[@"teamsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"teams_url"]] ?: NSNull.null;
    dictionaryValue[@"branchesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"branches_url"]] ?: NSNull.null;
    dictionaryValue[@"issueCommentURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"issue_comment_url"]] ?: NSNull.null;
    dictionaryValue[@"mergesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"merges_url"]] ?: NSNull.null;
    dictionaryValue[@"gitRefsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"git_refs_url"]] ?: NSNull.null;
    dictionaryValue[@"hooksURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"hooks_url"]] ?: NSNull.null;
    dictionaryValue[@"stargazersURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"stargazers_url"]] ?: NSNull.null;
    dictionaryValue[@"assigneesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"assignees_url"]] ?: NSNull.null;
    dictionaryValue[@"compareURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"compare_url"]] ?: NSNull.null;
    dictionaryValue[@"releasesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"releases_url"]] ?: NSNull.null;
    dictionaryValue[@"labelsRUL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"labels_url"]] ?: NSNull.null;
    dictionaryValue[@"downloadsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"downloads_url"]] ?: NSNull.null;

    dictionaryValue[@"updatedDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"updated_at"]] ?: NSNull.null;
    
    dictionaryValue[@"createdDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"created_at"]] ?: NSNull.null;
    
    return dictionaryValue;
}

@end
