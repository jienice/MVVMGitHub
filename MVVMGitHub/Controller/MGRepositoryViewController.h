//
//  MGRepositoryViewController.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewController.h"

@class MGRepositoryViewModel;
@interface MGRepositoryViewController : MGViewController


@property (nonatomic, strong, readonly) MGRepositoryViewModel *viewModel;

@end
