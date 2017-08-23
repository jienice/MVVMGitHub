//
//  MGRepoDetailViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

extern NSString *const kRepoDetailParamsKeyForRepoOwner;
extern NSString *const kRepoDetailParamsKeyForRepoName;

@class MGRepositoriesModel;

@interface MGRepoDetailViewModel : MGViewModel<MGTableViewModelProtocol>

@property (nonatomic, strong, readonly) NSString *readMEHtml;
@property (nonatomic, strong, readonly) OCTRepository *repo;
@property (nonatomic, strong, readonly) OCTTree *fileTree;
@property (nonatomic, strong, readonly) RACCommand *watchRepoCommand;
@property (nonatomic, strong, readonly) RACCommand *starRepoCommand;
@property (nonatomic, strong, readonly) RACCommand *forkRepoCommand;
@property (nonatomic, strong, readonly) RACCommand *fetchBranchsCommand;
@property (nonatomic, strong, readonly) RACCommand *fetchRepoCommand;
@property (nonatomic, strong, readonly) RACCommand *fetchTreeCommand;
@property (nonatomic, strong, readonly) NSArray *branches;
@property (nonatomic, copy) NSString *currentBranchName;



@property (nonatomic, strong, readonly) RACCommand *nameClickedCommand;
@property (nonatomic, strong, readonly) RACCommand *branchClickedCommand;
@end
