//
//  MGViewControllerProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGReactiveViewProtocol.h"

@protocol MGViewControllerProtocol <NSObject,MGReactiveViewProtocol>


- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel;


@optional
- (void)configUI;

@end
