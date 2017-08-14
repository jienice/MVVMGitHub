//
//  UIBarButtonItem+MGAdd.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "UIBarButtonItem+MGAdd.h"

@implementation UIBarButtonItem (MGAdd)

+ (instancetype)barButtonItemWithImage:(NSString *)imageName actionBlock:(void(^)())block{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithImage:image actionBlock:^(id sender) {
        if (block) {
            block();
        }
    }];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
+ (instancetype)barButtonItemWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor actionBlock:(void (^)())block{
    UIButton *btn = [UIButton buttonWithTitle:title titleFont:font titleColor:titleColor actionBlock:^(id sender) {
        if (block) {
            block();
        }
    }];
    CGFloat width = [title widthForFont:font];
    CGFloat height = 40.f;
    btn.frame = CGRectMake(0, 0, width, height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
+ (instancetype)barButtonItemForPopViewController{
    return [UIBarButtonItem barButtonItemWithImage:@"icon_back" actionBlock:^{
        [MGSharedDelegate.viewModelBased popViewModelAnimated:YES];
    }];
}
@end
