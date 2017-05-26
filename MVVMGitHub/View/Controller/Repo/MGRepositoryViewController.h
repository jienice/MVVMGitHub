//
//  MGRepositoryViewController.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewController.h"


@class MGRepositoryViewModel;

@interface MGRepositoryViewController : MGViewController<MGViewControllerProtocol>

@property (nonatomic, weak, readonly) MGRepositoryViewModel *viewModel;

@end
