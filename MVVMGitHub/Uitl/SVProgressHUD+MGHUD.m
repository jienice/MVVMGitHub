//
//  SVProgressHUD+MGHUD.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "SVProgressHUD+MGHUD.h"

@implementation SVProgressHUD (MGHUD)



+ (void)dismissHUD{
    
    if ([self isVisible]) {
        [self dismiss];
    }
}

@end
