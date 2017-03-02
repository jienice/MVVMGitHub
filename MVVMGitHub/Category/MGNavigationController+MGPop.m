//
//  MGNavigationController+MGPop.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/3/2.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGNavigationController+MGPop.h"

@implementation MGNavigationController (MGPop)


- (void)popViewControllerAnimated:(BOOL)animated{
    
    [MGSharedDelegate.viewModelBased popViewModelAnimated:animated];
}


@end
