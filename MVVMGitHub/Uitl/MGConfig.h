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
#define MG_Service_URL @"http://com.xingjie.mvvmgithub"
#define MG_Client_ID @"e44fe151f15da8da1e3c"
#define MG_Client_Secret @"78d6772432e956f8a73ba19fcbf1834b70dbfeb4"

///-------------
///  APPDelegate
///-------------
#define MGSharedDelegate ((MGAppDelegate *)[UIApplication sharedApplication].delegate)

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
#define MGSSKeychain_LoginService @"com.xingjie.mvvmgithub.login"
#define MGSSKeychain_UserName @"userName"
#define MGSSKeychain_PassWord @"passWord"
#define MGSSKeychain_RawLogin @"rawLogin"
#define MGSSKeychain_AccessToken @"accessToken"


///------------
///  UIColor
///------------
#define RGBAlphaColor(R,G,B, alp) [UIColor colorWithRed:((R) / 255.0) green:((G) / 255.0) blue:((B) / 255.0) alpha:alp]
#define RGBColor(R, G, B) RGBAlphaColor(R,G,B, 1.f)
#define MGGitHub_Color RGBColor(97, 186, 58)

///------------
///  system
///------------
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define TAB_BAR_HEIGHT 49


