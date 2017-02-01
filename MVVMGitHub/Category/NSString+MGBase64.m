//
//  NSString+MGBase64.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "NSString+MGBase64.h"

@implementation NSString (MGBase64)

- (NSString *)mg_stringEncodeToBase64{
    
    NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:self options:0];
    NSString *base64Decoded = [[NSString alloc]initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
}
- (NSString *)mg_base64EncodeToString{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
@end
