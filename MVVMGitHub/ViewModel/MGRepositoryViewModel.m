//
//  MGRepositoryViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoryViewModel.h"

@interface MGRepositoryViewModel ()
@end

@implementation MGRepositoryViewModel

@synthesize page = _page;
@synthesize dataSource = _dataSource;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize cancelFetchDataSignal = _cancelFetchDataSignal;

- (void)initialize{
    
    NSLog(@"%s",__func__);
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        if (self.cancelFetchDataSignal==nil) {
            self.cancelFetchDataSignal = self.rac_willDeallocSignal;
            NSLog(@"请设置取消请求的信号,如果不设置则默认为-rac_willDeallocSignal");
        }
        return [[self fetchDataFromServiceWithPage:0] takeUntil:self.cancelFetchDataSignal];
    }];
    
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
}
- (RACSignal *)fetchDataFromServiceWithPage:(NSInteger)page{
    
    return [[[MGSharedDelegate.client fetchUserRepositories] collect] doNext:^(NSArray<OCTRepository *>*repositories) {
        self.dataSource = [repositories mutableCopy];
    }];
}
@end
