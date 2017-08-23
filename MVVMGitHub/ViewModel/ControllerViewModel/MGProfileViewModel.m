//
//  MGUserViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGProfileViewModel.h"
#import "MGApiImpl+MGUser.h"
#import "MGUser.h"
#import "MGOrganizations.h"
#import "MGFollowerViewModel.h"
#import "MGFollowingViewModel.h"
#import "MGRepositoryViewModel.h"

NSString *const kProfileOfUserLoginName = @"kProfileOfUserLoginName";
NSString *const kProfileIsShowOnTabBar = @"kProfileIsShowOnTabBar";

@interface MGProfileViewModel ()

@property (nonatomic, strong, readwrite) MGUser *user;
@property (nonatomic, strong, readwrite) NSMutableArray *notificationsArray;
@property (nonatomic, strong, readwrite) NSMutableArray *orgArray;
@property (nonatomic, strong, readwrite) RACCommand *fetchFeedsCommand;

@property (nonatomic, strong, readwrite) RACCommand *fetchUserInfoCommand;

@property (nonatomic, strong, readwrite) RACCommand *fetchUserOrgCommand;

@property (nonatomic, strong, readwrite) RACCommand *fetchNotificationsCommand;

@property (nonatomic, strong, readwrite) RACCommand *markNotificationAsReadCommand;

@property (nonatomic, strong, readwrite) RACCommand *muteNotificationCommand;

@property (nonatomic, copy, readwrite) NSString *loginName;

@property (nonatomic, assign) BOOL isShowOnTabBar;

@property (nonatomic, strong, readwrite) RACCommand *clickedCategoryCommand;

@end


@implementation MGProfileViewModel

@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;


- (void)initialize{
    NSParameterAssert(self.params[kProfileOfUserLoginName]);
    NSParameterAssert(self.params[kProfileIsShowOnTabBar]);
    @weakify(self);
    self.loginName = self.params[kProfileOfUserLoginName];
    self.isShowOnTabBar=[self.params[kProfileIsShowOnTabBar] boolValue];
    
    if (self.isShowOnTabBar) {
        self.title = @"Profile";
    }else{
        self.title = self.loginName;
    }
    
    self.fetchUserInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[MGApiImpl sharedApiImpl] fetchUserInfoWithLoginName:self.loginName] takeUntil:self.rac_willDeallocSignal] doNext:^(NSDictionary *x) {
            @strongify(self);
            self.user = [MTLJSONAdapter modelOfClass:[MGUser class]
                                  fromJSONDictionary:x error:nil];
            NSLog(@"%@",self.user);
        }];
    }];
    
    self.fetchUserOrgCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[MGApiImpl sharedApiImpl]fetchUserOrgListWithLoginName:self.loginName] takeUntil:self.rac_willDeallocSignal] doNext:^(NSArray *orgs) {
            @strongify(self);
            self.orgArray =[[[orgs.rac_sequence map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGOrganizations class]
                                 fromJSONDictionary:value error:nil];
            }] array] mutableCopy];
            NSLog(@"self.orgArray --- %@",self.orgArray);
        }];
    }];
    
    self.fetchNotificationsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[MGSharedDelegate.client fetchNotificationsNotMatchingEtag:nil
                                                    includeReadNotifications:YES
                                                                updatedSince:nil] collect] takeUntil:self.rac_willDeallocSignal] doNext:^(NSArray *responseArray) {
            @strongify(self);
            self.notificationsArray = [[[responseArray.rac_sequence map:^OCTNotification *(OCTResponse *response) {
                return response.parsedResult;
            }] array] mutableCopy];
            NSLog(@"self.notificationsArray---%@",self.notificationsArray);
        }];
    }];
    
    self.markNotificationAsReadCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSURL *input) {
        return [MGSharedDelegate.client markNotificationThreadAsReadAtURL:input];
    }];
    
    self.muteNotificationCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSURL *input) {
        return [MGSharedDelegate.client muteNotificationThreadAtURL:input];
    }];
    
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.fetchUserInfoCommand execute:nil];
        [self.fetchUserOrgCommand execute:nil];
        if (self.isShowOnTabBar) {
            [self.fetchNotificationsCommand execute:nil];
        }
        return [RACSignal empty];
    }];
    
    
    self.clickedCategoryCommand = [[RACCommand alloc]initWithEnabled:[[RACObserve(self, user) ignore:NULL] map:^id(id value) {
        return value?@YES:@NO;
    }] signalBlock:^RACSignal *(NSNumber *typeNumber) {
        MGProfileCategoryType type = (MGProfileCategoryType) typeNumber.integerValue;
        switch (type) {
            case MGProfileCategoryTypeOfFollower:{
                MGFollowerViewModel *follower =
                [[MGFollowerViewModel alloc]initWithParams:@{kProfileOfUserLoginName:self.loginName}];
                [MGSharedDelegate.viewModelBased pushViewModel:follower animated:YES];
                NSLog(@"MGProfileCategoryTypeOfFollower - %s",__func__);
            }
                break;
            case MGProfileCategoryTypeOfFollowing:{
                MGFollowingViewModel *following =
                [[MGFollowingViewModel alloc]initWithParams:@{kProfileOfUserLoginName:self.loginName}];
                [MGSharedDelegate.viewModelBased pushViewModel:following animated:YES];
                NSLog(@"MGProfileCategoryTypeOfFollowing - %s",__func__);
            }
                break;
            case MGProfileCategoryTypeOfPublicRepo:{
                MGRepositoryViewModel *repo =
                [[MGRepositoryViewModel alloc]initWithParams:@{kListRepositoriesUserName:self.loginName,kRepositorIsShowOnTabBar:@NO}];
                [MGSharedDelegate.viewModelBased pushViewModel:repo animated:YES];
                NSLog(@"MGProfileCategoryTypeOfPublicRepo - %s",__func__);
            }
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
    
}


@end
