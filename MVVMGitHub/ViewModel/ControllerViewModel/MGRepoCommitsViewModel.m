//
//  MGRepoCommitsViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/16.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoCommitsViewModel.h"

NSString *const kRepoForKnowCommits = @"kRepoForKnowCommits";
NSString *const kSHAForKnowCommits = @"kSHAForKnowCommits";


@interface MGRepoCommitsViewModel ()


@end

@implementation MGRepoCommitsViewModel

@synthesize page                        = _page;
@synthesize dataSource                  = _dataSource;
@synthesize didSelectedRowCommand       = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (void)initialize{
    
    NSParameterAssert([self.params objectForKey:kRepoForKnowCommits]);
    NSParameterAssert([self.params objectForKey:kSHAForKnowCommits]);
    _repo = [self.params objectForKey:kRepoForKnowCommits];
    _SHA = [self.params objectForKey:kSHAForKnowCommits];
    self.title = [NSString stringWithFormat:@"Commits-%@",self.repo.name];

    _fetchCommitCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[MGSharedDelegate.client fetchCommitsFromRepository:_repo SHA:_SHA] collect];
    }];
    

    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[_fetchCommitCommand execute:nil] subscribeNext:^(NSArray<OCTGitCommit *> *commits) {
                _dataSource = [commits mutableCopy];
                [subscriber sendNext:RACTuplePack(@YES,@YES,_dataSource)];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
            return nil;
        }] deliverOn:RACScheduler.mainThreadScheduler];
    }];
    
}

@end
