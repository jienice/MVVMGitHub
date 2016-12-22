//
//  MGProgressHUD.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MGProgressHUD : NSObject


+ (void)dismiss;

+ (void)showText:(NSString *)text maskType:(SVProgressHUDMaskType)maskType;


@end
