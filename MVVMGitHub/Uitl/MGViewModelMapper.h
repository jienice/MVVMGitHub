//
//  MGViewModelMapper.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MGViewModelMapper : NSObject


- (UIViewController<MGViewControllerProtocol> *)viewControllerForViewModel:(id<MGViewModelProtocol>)viewModel;


@end
