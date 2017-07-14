//
//  MGOrganizations.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGOrganizations.h"

@implementation MGOrganizations

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
            @{@"publicMembersURL":@"public_members_url",
              @"eventsURL":@"events_url",
              @"URL":@"url",
              @"membersURL":@"members_url",
              @"issuesURL":@"issues_url",
              @"reposURL":@"repos_url",
              @"hooksURL":@"hooks_url",
              @"avatarURL":@"avatar_url",
              @"desc":@"description"}];
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
    
    dictionaryValue[@"publicMembersURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"public_members_url"]] ?: NSNull.null;
    
    dictionaryValue[@"eventsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"events_url"]] ?: NSNull.null;
    
    dictionaryValue[@"membersURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"members_url"]] ?: NSNull.null;
    
    dictionaryValue[@"issuesURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"issues_url"]] ?: NSNull.null;
    
    dictionaryValue[@"reposURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"repos_url"]] ?: NSNull.null;
    
    dictionaryValue[@"hooksURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"hooks_url"]] ?: NSNull.null;
    return dictionaryValue;
}
@end
