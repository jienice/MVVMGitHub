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

NSString *const kProfileOfUserLoginName = @"kProfileOfUserLoginName";
NSString *const kProfileIsShowOnTabBar = @"kProfileIsShowOnTabBar";

@interface MGProfileViewModel ()

@property (nonatomic, strong, readwrite) MGUser *user;
@property (nonatomic, strong, readwrite) NSMutableArray *notificationsArray;
@property (nonatomic, strong, readwrite) NSMutableArray *orgArray;
@property (nonatomic, assign) BOOL isShowOnTabBar;

@end


@implementation MGProfileViewModel

@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;


- (void)initialize{
    
    @weakify(self);
    NSParameterAssert(self.params[kProfileOfUserLoginName]);
    NSParameterAssert(self.params[kProfileIsShowOnTabBar]);
    _loginName = self.params[kProfileOfUserLoginName];
    self.isShowOnTabBar=[self.params[kProfileIsShowOnTabBar] boolValue];
    
    if (self.isShowOnTabBar) {
        self.title = @"Profile";
    }else{
        self.title = _loginName;
    }
    _fetchUserInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[MGApiImpl sharedApiImpl] fetchUserInfoWithLoginName:self.loginName] takeUntil:self.rac_willDeallocSignal] doNext:^(NSDictionary *x) {
            self.user = [MTLJSONAdapter modelOfClass:[MGUser class]
                                  fromJSONDictionary:x error:nil];
            NSLog(@"%@",_user);
        }];
    }];
    
    _fetchUserOrgCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[MGApiImpl sharedApiImpl]fetchUserOrgListWithLoginName:self.loginName] takeUntil:self.rac_willDeallocSignal] doNext:^(NSArray *orgs) {
            self.orgArray =[[[orgs.rac_sequence map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGOrganizations class]
                                 fromJSONDictionary:value error:nil];
            }] array] mutableCopy];
            NSLog(@"_orgArray --- %@",_orgArray);
        }];
    }];
    
    _fetchNotificationsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[MGSharedDelegate.client fetchNotificationsNotMatchingEtag:nil
                                                    includeReadNotifications:YES
                                                                updatedSince:nil] collect] takeUntil:self.rac_willDeallocSignal] doNext:^(NSArray *responseArray) {
            self.notificationsArray = [[[responseArray.rac_sequence map:^OCTNotification *(OCTResponse *response) {
                return response.parsedResult;
            }] array] mutableCopy];
            NSLog(@"_notificationsArray---%@",_notificationsArray);
        }];
    }];
    
    _markNotificationAsReadCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSURL *input) {
        return [MGSharedDelegate.client markNotificationThreadAsReadAtURL:input];
    }];
    
    _muteNotificationCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSURL *input) {
        return [MGSharedDelegate.client muteNotificationThreadAtURL:input];
    }];
    
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [_fetchUserInfoCommand execute:nil];
        [_fetchUserOrgCommand execute:nil];
        if (self.isShowOnTabBar) {
            [_fetchNotificationsCommand execute:nil];
        }
        return [RACSignal empty];
    }];
    
}


@end
