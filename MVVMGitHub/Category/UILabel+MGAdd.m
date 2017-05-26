//
//  UILabel+MGAdd.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/5/25.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "UILabel+MGAdd.h"

@implementation UILabel (MGAdd)


+ (instancetype)blackTextWithSystemFontSize:(CGFloat)systemFontSize{
    
    UILabel *label = [UILabel textColor:[UIColor blackColor] systemFontSize:systemFontSize];
    return label;
}


+ (instancetype)textColor:(UIColor *)textColor systemFontSize:(CGFloat)systemFontSize{
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:systemFontSize];
    return label;
}

@end
