//
//  MGNavigationControllerProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/23.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGViewModel;
@protocol MGNavigationControllerProtocol <NSObject>

@property(nonatomic,readonly,assign) id<MGViewModelProtocol> topViewModel;

@property(nonatomic,readonly,strong) NSMutableArray *viewModels;

- (void)pushViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)popViewModelAnimated:(BOOL)animated;

- (void)popToViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)presentViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)dissMissViewModel:(id<MGViewModelProtocol>)viewModel animated:(BOOL)animated;
@end
