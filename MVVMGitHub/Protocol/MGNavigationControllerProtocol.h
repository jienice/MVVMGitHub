//
//  MGNavigationControllerProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/23.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGNavigationControllerProtocol <NSObject>

- (void)pushViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)presentViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)dissMissViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)popViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;


@end
