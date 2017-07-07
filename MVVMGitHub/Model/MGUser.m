//
//  MGUser.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGUser.h"

@implementation MGUser

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey
            mtl_dictionaryByAddingEntriesFromDictionary:
  @{@"URL":@"url",
    @"followingURL":@"following_url",
    @"eventsURL":@"events_url",
    @"receivedEventsURL":@"received_events_url",
    @"subscriptionsURL": @"subscriptions_url",
    @"gistsURL":@"gists_url",
    @"starredURL":@"starred_url",
    @"organizationsURL":@"organizations_url",
    @"reposURL":@"repos_url",
    @"followersURL":@"followers_url",
    @"htmlURL":@"html_url",
    @"followersCount":@"followers",
    @"followingCount":@"following",
    @"publicGistsCount":@"public_gists",
    @"updatedDate":@"updated_at",
    @"createdDate":@"created_at"}];
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
    
    dictionaryValue[@"followingURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"following_url"]] ?: NSNull.null;
    
    dictionaryValue[@"eventsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"events_url"]] ?: NSNull.null;
    
    dictionaryValue[@"receivedEventsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"received_events_url"]] ?: NSNull.null;
    
    dictionaryValue[@"subscriptionsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"subscriptions_url"]] ?: NSNull.null;
    
    dictionaryValue[@"gistsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"gists_url"]] ?: NSNull.null;
    
    dictionaryValue[@"starredURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"starred_url"]] ?: NSNull.null;
    
    dictionaryValue[@"organizationsURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"organizations_url"]] ?: NSNull.null;
    
    dictionaryValue[@"reposURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"repos_url"]] ?: NSNull.null;
    
    dictionaryValue[@"htmlURL"] = [self.URLJSONTransformer transformedValue:externalRepresentation[@"html_url"]] ?: NSNull.null;
    
    dictionaryValue[@"updatedDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"updated_at"]] ?: NSNull.null;
    
    dictionaryValue[@"createdDate"] = [self.dateJSONTransformer transformedValue:externalRepresentation[@"created_at"]] ?: NSNull.null;
    
    dictionaryValue[@"followersCount"] = externalRepresentation[@"followers"]?:@0;
    dictionaryValue[@"followingCount"] = externalRepresentation[@"followingCount"]?:@0;

    
    return dictionaryValue;
}


@end
