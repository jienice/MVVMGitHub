//
//  MGRepoDetailViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"
@class MGRepositoriesModel;


@interface MGRepoDetailViewModel : MGViewModel


@property (nonatomic, strong, readonly) OCTRepository *repo;

@property (nonatomic, strong, readonly) NSString *readMEHtml;

@property (nonatomic, strong, readonly) OCTTree *fileTree;

@property (nonatomic, strong, readonly) RACCommand *fetchRepoBranchsCommand;
@property (nonatomic, strong, readonly) RACCommand *watchRepoCommand;
@property (nonatomic, strong, readonly) RACCommand *starRepoCommand;
@property (nonatomic, strong, readonly) RACCommand *forkRepoCommand;

- (instancetype)initWithRepo:(MGRepositoriesModel *)repo;


@end
