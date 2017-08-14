//
//  UIBarButtonItem+MGAdd.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "UIBarButtonItem+MGAdd.h"

@implementation UIBarButtonItem (MGAdd)

+ (instancetype)barButtonItemWithImage:(NSString *)imageName actionBlock:(MGBarButtonItemActionBlock)block{
    MGBarButtonItemActionBlock blockCopy = [block copy];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (blockCopy) {
            blockCopy();
        }
    }];
    return item;
}
+ (instancetype)barButtonItemForPopViewController{
    return [UIBarButtonItem barButtonItemWithImage:@"icon_back" actionBlock:^{
        [MGSharedDelegate.viewModelBased popViewModelAnimated:YES];
    }];
}
@end
