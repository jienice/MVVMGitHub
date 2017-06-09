//
//  UIBarButtonItem+MGAdd.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "UIBarButtonItem+MGAdd.h"

@implementation UIBarButtonItem (MGAdd)

+ (instancetype)barButtonItemForPopViewController{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [MGSharedDelegate.viewModelBased popViewModelAnimated:YES];
    }];
    return item;
}

@end
