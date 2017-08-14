//
//  UIButton+MGAdd.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/8/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "UIButton+MGAdd.h"

@implementation UIButton (MGAdd)

+ (instancetype)buttonWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor actionBlock:(void (^)(id sender))block{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateHighlighted];
    [btn setTitleColor:titleColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateSelected];
    if (block) {
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            block(btn);
        }];
    }
    return btn;
}

+ (instancetype)buttonWithImage:(UIImage *)image actionBlock:(void(^)(id sender))block;{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateSelected];
    if (block) {
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            block(btn);
        }];
    }
    return btn;
}
@end
