//
//  MGProgressHUD.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGProgressHUD.h"

@implementation MGProgressHUD

+ (void)showText:(NSString *)text maskType:(SVProgressHUDMaskType)maskType{
    
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD showWithStatus:text];
}


+ (void)dismiss{
    
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}
@end
