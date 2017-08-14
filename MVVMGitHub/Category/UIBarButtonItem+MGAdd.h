//
//  UIBarButtonItem+MGAdd.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (MGAdd)

+ (instancetype)barButtonItemForPopViewController;

+ (instancetype)barButtonItemWithImage:(NSString *)imageName actionBlock:(void(^)())block;

+ (instancetype)barButtonItemWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor actionBlock:(void (^)())block;


@end
