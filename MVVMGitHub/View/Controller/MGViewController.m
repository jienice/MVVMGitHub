//
//  MGViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/3/1.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewController.h"

@interface MGViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MGViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - Dealloc
- (void)dealloc{
    
    NSLog(@"%s",__func__);
}


@end
