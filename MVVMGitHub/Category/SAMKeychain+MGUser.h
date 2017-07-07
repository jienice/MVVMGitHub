//
//  SAMKeychain+MGUser.h
//  MVVMGitHub
//
//  Created by xingjie on 2017/2/1.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <SAMKeychain/SAMKeychain.h>

@interface SAMKeychain (MGUser)

+ (NSString *)mg_passWord;
+ (NSString *)mg_rawlogin;
+ (NSString *)mg_accessToken;
+ (NSString *)mg_preferenceLanguage;
+ (NSString *)mg_login;
+ (NSString *)mg_name;


+ (void)mg_setAccessToken:(NSString *)accessToken;
+ (void)mg_setPassWord:(NSString *)passWord;
+ (void)mg_setRawlogin:(NSString *)rawlogin;
+ (void)mg_setPreferenceLanguage:(NSString *)preferenceLanguage;
+ (void)mg_setlogin:(NSString *)login;
+ (void)mg_setName:(NSString *)name;


+ (void)mg_deleteAccessToken;
+ (void)mg_deletePassWord;
+ (void)mg_deleteRawlogin;
+ (void)mg_deleteLogin;
+ (void)mg_deleteName;


@end
