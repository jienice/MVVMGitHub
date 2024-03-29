//
//  MGFollowingViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGFollowingViewModel.h"
#import "MGApiImpl+MGUser.h"
#import "MGUser.h"
#import "MGProfileViewModel.h"

@interface MGFollowingViewModel ()

@property (nonatomic, copy) NSString *loginName;

@end

@implementation MGFollowingViewModel

@synthesize dataSource = _dataSource;
@synthesize page = _page;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;


- (void)initialize{
    NSParameterAssert(self.params[kProfileOfUserLoginName]);
    
    self.loginName = self.params[kProfileOfUserLoginName];
    self.title = [NSString stringWithFormat:@"%@-Following",self.loginName];
    @weakify(self);
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchUserFollowingListWithLoginName:self.loginName] doNext:^(NSArray *array) {
            @strongify(self);
            self.dataSource = [[[array.rac_sequence map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGUser class]
                                 fromJSONDictionary:value error:nil];
            }] array] mutableCopy];
        }];
    }];
    
    
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        OCTUser *user = self.dataSource[indexPath.row];
        MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                       initWithParams:@{kProfileOfUserLoginName:user.login,
                                                        kProfileIsShowOnTabBar:@NO}];
        [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
        return [RACSignal empty];
    }];
    
}

@end
