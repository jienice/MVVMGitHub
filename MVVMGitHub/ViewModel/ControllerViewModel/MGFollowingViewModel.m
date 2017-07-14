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
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchUserFollowingListWithLoginName:self.loginName] doNext:^(NSArray *array) {
            self.dataSource = [[[array.rac_sequence map:^id(NSDictionary *value) {
                return [MTLJSONAdapter modelOfClass:[MGUser class]
                                 fromJSONDictionary:value error:nil];
            }] array] mutableCopy];
        }];
    }];
    
}

@end
