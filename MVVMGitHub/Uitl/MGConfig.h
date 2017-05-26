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
#define MGSSKeychain_PreferenceLanguage @"preferenceLanguage"

///------------
///  UIColor
///------------
#define MGRGBAlphaColor(R,G,B, alp) [UIColor colorWithRed:((R) / 255.0) green:((G) / 255.0) blue:((B) / 255.0) alpha:alp]
#define MGRGBColor(R, G, B) MGRGBAlphaColor(R,G,B, 1.f)
#define MGClickedColor MGRGBColor(97, 186, 58)
#define MGNormalColor [UIColor lightGrayColor]
#define MGWhiteColor [UIColor whiteColor]
///------------
///  system
///------------
#define MGSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MGSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define MGTAB_BAR_HEIGHT 49
#define MGSTATUS_BAR_HEIGHT 20

///------------
///  Block
///------------
typedef NSString*(^string_IndexPathBlock)(NSIndexPath *indexPath);
typedef CGFloat (^float_IndexPathBlock)(NSIndexPath *indexPath);











