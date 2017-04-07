//
//  MGViewControllerProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGViewModelProtocol.h"

@protocol MGViewControllerProtocol <NSObject>


- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel;


- (void)bindViewModel;

@optional
- (void)configUI;

@end
