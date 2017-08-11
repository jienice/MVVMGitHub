//
//  MGFollowerViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGFollowerViewModel.h"
#import "MGApiImpl+MGUser.h"
#import "MGUser.h"
#import "MGProfileViewModel.h"

@interface MGFollowerViewModel()

@property (nonatomic, copy) NSString *loginName;

@end

@implementation MGFollowerViewModel

@synthesize dataSource = _dataSource;
@synthesize page = _page;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;


- (void)initialize{
    
    NSParameterAssert(self.params[kProfileOfUserLoginName]);
    self.loginName = self.params[kProfileOfUserLoginName];
    self.title = [NSString stringWithFormat:@"%@-Followers",self.loginName];
    @weakify(self);
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchUserFollowersListWithLoginName:self.loginName] doNext:^(NSArray *array) {
            self.dataSource = [[[array.rac_sequence map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGUser class]
                                 fromJSONDictionary:value error:nil];
            }] array] mutableCopy];
        }];
    }];
    
}


@end
