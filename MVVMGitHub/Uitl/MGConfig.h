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
#define MGFont(size) [UIFont systemFontOfSize:size]
#define MGBlodFont(size) [UIFont boldSystemFontOfSize:size]
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
#define MGSSKeychain_Login @"login"
#define MGSSKeychain_PassWord @"passWord"
#define MGSSKeychain_RawLogin @"rawLogin"
#define MGSSKeychain_AccessToken @"accessToken"
#define MGSSKeychain_PreferenceLanguage @"preferenceLanguage"
#define MGSSKeychain_ObjectID @"ObjectID"

///------------
///  UIColor
///------------
#define MGRGBAlphaColor(R,G,B, alp) [UIColor colorWithRed:((R) / 255.0) green:((G) / 255.0) blue:((B) / 255.0) alpha:alp]
#define MGRGBColor(R, G, B) MGRGBAlphaColor(R,G,B, 1.f)
#define MGNormalColor [UIColor lightGrayColor]
#define MGWhiteColor [UIColor whiteColor]
#define MGBlackColor [UIColor blackColor]
#define MGSystemColor MGRGBColor(3, 102, 214)//x0366D6

///------------
///  system
///------------
#define MGSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MGSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define MGTAB_BAR_HEIGHT 49
#define MGSTATUS_BAR_HEIGHT 20
#define MGNAV_BAR_HEIGHT 44
#define MGNAV_STATUS_BAR_HEIGHT 64

///------------
///  Error
///------------
#define kNetWorkRequestError(ErrorCode,ErrorMessage)\
                [NSError errorWithDomain:MGCocoaErrorDomain\
                                    code:ErrorCode\
                                userInfo:@{kErrorMessageKey:ErrorMessage}]

///------------
///  Search
///------------
#define MGSEARCH_MENU_HEIGHT 40








