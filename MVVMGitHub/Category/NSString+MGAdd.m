//
//  NSString+MGAdd.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/15.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "NSString+MGAdd.h"

@implementation NSString (MGAdd)

- (BOOL)isExist{
    
    return self&&![self isKindOfClass:[NSNull class]]&&![self isEqualToString:@""];
}
- (NSString *)readMeHtmlString{
    
    return [NSString stringWithFormat:@"<!DOCTYPE html>\
            <html>\
            <style type=\"text/css\">\
            h1 {font-family: Georgia; font-size: 34px;}\
            h2 {font-family: Georgia; font-size: 32px;}\
            h3 {font-family: Georgia; font-size: 28px;}\
            p  {font-family: Georgia; font-size: 28px;};\
            </style>\
            <head>\
            <title></title>\
            </head>\
            <body>\
             %@ \
            </body>\
            </html>",self];
}
@end


