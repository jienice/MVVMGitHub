//
//  MGMainViewController.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGViewControllerProtocol.h"

@class MGMainViewModel;

@interface MGMainViewController : UITabBarController<MGViewControllerProtocol>

@property (nonatomic, strong, readonly) MGMainViewModel *viewModel;


@end
