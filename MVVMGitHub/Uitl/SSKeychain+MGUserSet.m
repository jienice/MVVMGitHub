//
//  SSKeychain+MGUserSet.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "SSKeychain+MGUserSet.h"

@implementation SSKeychain (MGUserSet)

+ (NSString *)mg_rawlogin{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:MGSSKeychain_RawLogin];
}
+ (NSString *)mg_passWord{
    
    return [self passwordForService:MGSSKeychain_LoginService account:MGSSKeychain_PassWord];
}
+ (NSString *)mg_accessToken{
    
    return [self passwordForService:MGSSKeychain_LoginService account:MGSSKeychain_AccessToken];
}

+ (void)mg_setAccessToken:(NSString *)accessToken{
    
    if (accessToken == nil) NSLog(@"%s accessToken is nil",__func__);
    [self setPassword:accessToken forService:MGSSKeychain_LoginService account:MGSSKeychain_AccessToken];
}
+ (void)mg_setPassWord:(NSString *)passWord{
    
    if (passWord == nil) NSLog(@"%s passWord is nil",__func__);
    [self setPassword:passWord forService:MGSSKeychain_LoginService account:MGSSKeychain_PassWord];
}
+ (void)mg_setRawlogin:(NSString *)rawlogin{
    
    if (rawlogin == nil) NSLog(@"%s rowlogin is nil",__func__);
    [[NSUserDefaults standardUserDefaults] setObject:rawlogin forKey:MGSSKeychain_RawLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)mg_deleteAccessToken{
    
    [self deletePasswordForService:MGSSKeychain_LoginService account:MGSSKeychain_AccessToken];
    
}
+ (void)mg_deletePassWord{
    
    [self deletePasswordForService:MGSSKeychain_LoginService account:MGSSKeychain_PassWord];
}
+ (void)mg_deleteRawlogin{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MGSSKeychain_RawLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end