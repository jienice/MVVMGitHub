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
    [btn setTitleColorForAllState:titleColor];
    [btn setTitleForAllState:title];
    if (block) {
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            block(btn);
        }];
    }
    return btn;
}

+ (instancetype)buttonWithImage:(UIImage *)image actionBlock:(void(^)(id sender))block;{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImageForAllState:image];
    if (block) {
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            block(btn);
        }];
    }
    return btn;
}
- (void)setTitleForAllState:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
}
- (void)setImageForAllState:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
}
- (void)setTitleColorForAllState:(UIColor *)titleColor{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateSelected];
}
@end
