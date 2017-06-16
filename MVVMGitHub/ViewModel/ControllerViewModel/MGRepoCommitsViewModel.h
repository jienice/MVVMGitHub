//
//  MGRepoCommitsViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/16.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

extern NSString *const kRepoForKnowCommits;
extern NSString *const kSHAForKnowCommits;

@interface MGRepoCommitsViewModel : MGViewModel<MGTableViewModelProtocol>

@property (nonatomic, strong, readonly) OCTRepository *repo;

@property (nonatomic, strong, readonly) NSString *SHA;

@property (nonatomic, strong, readonly) RACCommand *fetchCommitCommand;


@end
