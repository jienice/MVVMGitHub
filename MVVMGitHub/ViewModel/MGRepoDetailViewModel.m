//
//  MGRepoDetailViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailViewModel.h"
#import "MGRepositoriesModel.h"


@interface MGRepoDetailViewModel()

@property (nonatomic, strong, readwrite) MGRepositoriesModel *repo;

@end

@implementation MGRepoDetailViewModel

- (instancetype)initWithRepo:(MGRepositoriesModel *)repo{
    
    if (self = [super init]) {
        self.repo = repo;
    }
    return self;
}


@end
