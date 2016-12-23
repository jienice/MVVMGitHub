//
//  MGConfig.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

///-------------
///   OAuth2
///-------------
#define MG_CAllBack_URL @"http://com.xingjie.mvvmgithub"
#define MG_Client_ID @"e44fe151f15da8da1e3c"
#define MG_Client_Secret @"cde7ce083876684b4429eca155cfaf01dfc1a5d3"


///-------------
///  APPDelegate
///-------------
#define MGAPPDelegate ((MGAppDelegate *)[UIApplication sharedApplication].delegate)

///-------------
///  UIFont
///-------------
#define MGFont(Size) [UIFont systemFontOfSize:Size]

///----------
///  UIView
///----------
#define MGViewCornerRadius(View,CornerRadius) {\
    if ([View isKindOfClass:[UIView class]]) {\
        View.layer.cornerRadius = CornerRadius;\
        View.layer.masksToBounds = YES;\
    }\
}
///-------------
///  SSKeychain
///-------------

#define MGSSKeychainLoginService @"com.xingjie.mvvmgithub.login"

///------------
///  UIColor
///------------
#define RGBAlphaColor(R,G,B, alp) [UIColor colorWithRed:((R) / 255.0) green:((G) / 255.0) blue:((B) / 255.0) alpha:alp]









