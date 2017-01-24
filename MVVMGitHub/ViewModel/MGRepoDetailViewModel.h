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


@property (nonatomic, strong, readonly) MGRepositoriesModel *repo;

- (instancetype)initWithRepo:(MGRepositoriesModel *)repo;


@end
