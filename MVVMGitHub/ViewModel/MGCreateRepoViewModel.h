//
//  MGCreateRepoViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@interface MGCreateRepoViewModel : MGViewModel


@property (nonatomic, copy) NSString *repoName;

@property (nonatomic, copy) NSString *repoDesc;

@property (nonatomic, assign) BOOL isPrivate;

@property (nonatomic, strong, readonly) RACSignal *canCreateSignal;

@property (nonatomic, strong) RACCommand *createRepoCommand;


@end
