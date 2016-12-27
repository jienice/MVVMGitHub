//
//  SSKeychain+MGUserSet.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>

@interface SSKeychain (MGUserSet)


+ (NSString *)mg_passWord;
+ (NSString *)mg_rawlogin;
+ (NSString *)mg_accessToken;

+ (void)mg_setAccessToken:(NSString *)accessToken;
+ (void)mg_setPassWord:(NSString *)passWord;
+ (void)mg_setRawlogin:(NSString *)rawlogin;


+ (void)mg_deleteAccessToken;
+ (void)mg_deletePassWord;
+ (void)mg_deleteRawlogin;

@end
