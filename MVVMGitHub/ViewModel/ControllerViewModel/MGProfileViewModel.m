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

NSString *const kProfileOfUserLoginName = @"kProfileOfUserLoginName";

@interface MGProfileViewModel ()

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, strong, readwrite) MGUser *user;

@property (nonatomic, assign) NSInteger followersPage;
@property (nonatomic, assign) NSInteger followingPage;


@end


@implementation MGProfileViewModel

@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;


- (void)initialize{
    
    @weakify(self);
    self.followersPage = 1;
    self.followingPage = 1;
    
    NSParameterAssert([self.params objectForKey:kProfileOfUserLoginName]);
    
    self.loginName = [self.params objectForKey:kProfileOfUserLoginName];
    
    _fetchUserInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchUserInfoWithLoginName:self.loginName] doNext:^(NSDictionary *x) {
            self.user = [MTLJSONAdapter modelOfClass:[MGUser class]
                                  fromJSONDictionary:x error:nil];
            NSLog(@"%@",_user);
        }];
    }];
    
    _fetchFollowersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchUserFollowersListWithLoginName:self.loginName
                                                                          page:self.followersPage] doNext:^(id x) {
            self.followersPage++;
        }];
    }];
    
    
    
    _fetchFollowingUsersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchUserFollowingListWithLoginName:self.loginName
                                                                          page:self.followingPage] doNext:^(id x) {
            self.followingPage++;
        }];
    }];
    
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [_fetchUserInfoCommand execute:nil];
        [_fetchFollowingUsersCommand execute:nil];
        [_fetchFollowersCommand execute:nil];
        NSArray *ARR = @[@"1",@"1212"];
        return [RACSignal return:RACTuplePack(@YES,@YES,ARR)];
    }];
    
}


@end
