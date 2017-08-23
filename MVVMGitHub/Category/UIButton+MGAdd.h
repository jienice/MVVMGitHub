//
//  UIButton+MGAdd.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/8/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MGAdd)

+ (instancetype)buttonWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor actionBlock:(void (^)(id sender))block;

+ (instancetype)buttonWithImage:(UIImage *)image actionBlock:(void(^)(id sender))block;


- (void)setTitleForAllState:(NSString *)title;
@end
