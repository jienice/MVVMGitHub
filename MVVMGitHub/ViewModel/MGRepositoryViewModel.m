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
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize requestDisposable = _requestDisposable;
@synthesize dataSource = _dataSource;

- (void)initialize{
    
    NSLog(@"%s",__func__);
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[self requestServiceDataWithPage:0] takeUntil:self.rac_willDeallocSignal];
    }];
    
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];

    
}
- (RACSignal *)requestServiceDataWithPage:(NSInteger)page{
    
    return [[MGSharedDelegate.client fetchUserStarredRepositories] collect];
//    return [[MGSharedDelegate.client fetchUserRepositories] collect];
}
@end
