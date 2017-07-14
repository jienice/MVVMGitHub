//
//  MGEvent.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/10.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGEvent.h"

@implementation MGActor

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"displayLogin":@"display_login",
              @"avatarURL":@"avatar_url",
              @"URL":@"url",
              @"gravatarID":@"gravatar_id"}];
}

+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation
                                                            version:(NSUInteger)fromVersion {
    
    NSMutableDictionary *dictionaryValue = [[super dictionaryValueFromArchivedExternalRepresentation:externalRepresentation
                                                                                             version:fromVersion]
                                            mutableCopy];
    
    dictionaryValue[@"URL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"url"]] ?: NSNull.null;
    
    dictionaryValue[@"avatarURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"avatar_url"]] ?: NSNull.null;
    return dictionaryValue;
}

@end

@implementation MGOrg

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"avatarURL":@"avatar_url",
              @"URL":@"url",
              @"gravatarID":@"gravatar_id"}];
}

+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation
                                                            version:(NSUInteger)fromVersion {
    
    NSMutableDictionary *dictionaryValue = [[super dictionaryValueFromArchivedExternalRepresentation:externalRepresentation
                                                                                             version:fromVersion]
                                            mutableCopy];
    
    dictionaryValue[@"URL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"url"]] ?: NSNull.null;
    
    dictionaryValue[@"avatarURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"avatar_url"]] ?: NSNull.null;
    return dictionaryValue;
}

@end

@implementation MGPullRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"patchURL":@"patch_url",
              @"URL":@"url",
              @"htmlURL":@"html_url",
              @"commentsURL":@"comments_url",
              @"reviewCommentURL":@"review_comment_url",
              @"issueURL":@"issue_url",
              @"diffURL":@"diff_url",
              @"statusesURL":@"statuses_url",
              @"reviewCommentsURL":@"review_comments_url",
              @"commitsURL":@"commits_url",
              @"changedFiles":@"changed_files",
              @"reviewComments":@"review_comments",
              @"mergeableState":@"mergeable_state",
              @"maintainerCanModify":@"maintainer_can_modify",
              @"updatedDate":@"updated_at",
              @"createdDate":@"created_at"}];
}

+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+ (NSValueTransformer *)dateJSONTransformer {
    return [NSValueTransformer valueTransformerForName:OCTDateValueTransformerName];
}
+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MGUser.class];
}

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation
                                                            version:(NSUInteger)fromVersion {
    
    NSMutableDictionary *dictionaryValue = [[super dictionaryValueFromArchivedExternalRepresentation:externalRepresentation
                                                                                             version:fromVersion]
                                            mutableCopy];
    
    dictionaryValue[@"URL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"url"]] ?: NSNull.null;
    
    dictionaryValue[@"avatarURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"avatar_url"]] ?: NSNull.null;
    
    dictionaryValue[@"htmlURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"html_url"]] ?: NSNull.null;
    
    dictionaryValue[@"commentsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"comments_url"]] ?: NSNull.null;
    
    dictionaryValue[@"reviewCommentURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"review_comment_url"]] ?: NSNull.null;
    
    dictionaryValue[@"issueURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"issue_url"]] ?: NSNull.null;
    
    dictionaryValue[@"diffURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"diff_url"]] ?: NSNull.null;
    
    dictionaryValue[@"statusesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"statuses_url"]] ?: NSNull.null;
    
    dictionaryValue[@"reviewCommentsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"review_comments_url"]] ?: NSNull.null;
    
    dictionaryValue[@"commitsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"commits_url"]] ?: NSNull.null;
    
    dictionaryValue[@"updatedDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"updated_at"]] ?: NSNull.null;
    
    dictionaryValue[@"createdDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"created_at"]] ?: NSNull.null;
    
    dictionaryValue[@"user"] = [self.userJSONTransformer transformedValue:externalRepresentation[@"user"]] ?: NSNull.null;
    
    return dictionaryValue;
}


@end

@implementation MGPayload

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"masterBranch":@"master_branch",
              @"pusherType":@"pusher_type",
              @"refType":@"ref_type",
              @"pullRequest":@"pull_request",
              @"desc":@"description"}];
}

+ (NSValueTransformer *)pullRequestJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MGPullRequest.class];
}
+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation
                                                            version:(NSUInteger)fromVersion {
    
    NSMutableDictionary *dictionaryValue = [[super dictionaryValueFromArchivedExternalRepresentation:externalRepresentation
                                                                                             version:fromVersion]
                                            mutableCopy];
    
    dictionaryValue[@"pullRequest"] = [self.pullRequestJSONTransformer transformedValue:externalRepresentation[@"pull_request"]] ?: NSNull.null;
    return dictionaryValue;
}
@end

@implementation MGEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"createdDate":@"created_at",
              @"isPublic":@"public"}];
}
+ (NSValueTransformer *)dateJSONTransformer {
    return [NSValueTransformer valueTransformerForName:OCTDateValueTransformerName];
}
+ (NSValueTransformer *)actorJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MGActor.class];
}
+ (NSValueTransformer *)repoJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MGRepositoriesModel.class];
}
+ (NSValueTransformer *)orgJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MGOrg.class];
}
+ (NSValueTransformer *)payloadJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MGPayload.class];
}
+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation
                                                            version:(NSUInteger)fromVersion {
    
    NSMutableDictionary *dictionaryValue = [[super dictionaryValueFromArchivedExternalRepresentation:externalRepresentation
                                                                                             version:fromVersion]
                                            mutableCopy];
    
    dictionaryValue[@"createdDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"created_at"]] ?: NSNull.null;
    dictionaryValue[@"actor"] = [self.actorJSONTransformer transformedValue:externalRepresentation[@"actor"]] ?: NSNull.null;
    dictionaryValue[@"repo"] = [self.repoJSONTransformer transformedValue:externalRepresentation[@"repo"]] ?: NSNull.null;
    dictionaryValue[@"org"] = [self.orgJSONTransformer transformedValue:externalRepresentation[@"org"]] ?: NSNull.null;
    dictionaryValue[@"payload"] = [self.payloadJSONTransformer transformedValue:externalRepresentation[@"payload"]] ?: NSNull.null;
    return dictionaryValue;
}

@end
