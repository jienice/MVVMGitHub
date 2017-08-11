//
//  SAMKeychain+MGUser.m
//  MVVMGitHub
//
//  Created by xingjie on 2017/2/1.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "SAMKeychain+MGUser.h"

@implementation SAMKeychain (MGUser)

#pragma mark - getter
+ (NSString *)mg_rawlogin{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:MGSSKeychain_RawLogin];
}
+ (NSString *)mg_passWord{
    
    return [self passwordForService:MGSSKeychain_LoginService account:MGSSKeychain_PassWord];
}
+ (NSString *)mg_accessToken{
    
    return [self passwordForService:MGSSKeychain_LoginService account:MGSSKeychain_AccessToken];
}
+ (NSString *)mg_preferenceLanguage{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:MGSSKeychain_PreferenceLanguage];
}
+ (NSString *)mg_name{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:MGSSKeychain_UserName];
}
+ (NSString *)mg_login{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:MGSSKeychain_Login];
}
+ (NSString *)mg_objectID{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:MGSSKeychain_ObjectID];
}
#pragma mark - setter
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
+ (void)mg_setPreferenceLanguage:(NSString *)preferenceLanguage{
    
    if (preferenceLanguage == nil) NSLog(@"%s preferenceLanguage is nil",__func__);
    [[NSUserDefaults standardUserDefaults] setObject:preferenceLanguage forKey:MGSSKeychain_PreferenceLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)mg_setlogin:(NSString *)login{
    
    if (login == nil) NSLog(@"%s preferenceLanguage is nil",__func__);
    [[NSUserDefaults standardUserDefaults] setObject:login forKey:MGSSKeychain_Login];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)mg_setName:(NSString *)name{
    
    if (name == nil) NSLog(@"%s name is nil",__func__);
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:MGSSKeychain_UserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)mg_setObjectID:(NSString *)objectID{
    
    if (objectID == nil) NSLog(@"%s objectID is nil",__func__);
    [[NSUserDefaults standardUserDefaults] setObject:objectID forKey:MGSSKeychain_ObjectID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - delete
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
+ (void)mg_deleteLogin{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MGSSKeychain_Login];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)mg_deleteName{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MGSSKeychain_UserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)mg_deleteObjectID{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MGSSKeychain_ObjectID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
