//
//  NSString+MGBase64.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MGBase64)

- (NSString *)mg_stringEncodeToBase64;

- (NSString *)mg_base64EncodeToString;

@end
