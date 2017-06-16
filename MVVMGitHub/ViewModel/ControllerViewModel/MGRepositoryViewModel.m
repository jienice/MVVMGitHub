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


- (void)initialize{
    
    self.title = @"Repository";
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[self fetchDataFromServiceWithPage:0] takeUntil:self.rac_willDeallocSignal];
    }];
    
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(OCTRepository *repository) {
        return [RACSignal empty];
    }];    
}

- (RACSignal *)fetchDataFromServiceWithPage:(NSInteger)page{
    
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[MGSharedDelegate.client fetchUserRepositories] collect] subscribeNext:^(NSArray<OCTRepository *>*repositories) {
            @strongify(self);
            NSLog(@"Next ----");
            self.dataSource = [repositories mutableCopy];
            [subscriber sendNext:RACTuplePack(@YES,@YES,self.dataSource)];
        } error:^(NSError *error) {
            NSLog(@"Error ----");
            [subscriber sendError:error];
        } completed:^{
            NSLog(@"Completed ----");
            [subscriber sendCompleted];
        }];
        return nil;
    }] deliverOn:RACScheduler.mainThreadScheduler];
}

@end
