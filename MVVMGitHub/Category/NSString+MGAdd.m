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
            p  {font-family: Georgia; font-size: 28px;}\
            </style>\
            <head>\
            <title></title>\
            </head>\
            <body width = \"device-width\",initial-scale=1.0, user-scalable=no>\
             %@ \
            </body>\
            </html>",self];
}
+ (NSString *)onlyYearMouthDayDateStringForCommitDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    NSDictionary *en_mouthDic = @{@1:@"Jan",@2:@"Feb",@3:@"Mar",@4:@"Apr",@5:@"May",@6:@"Jun",
                                  @7:@"Jul",@8:@"Aug",@9:@"Sep",@10:@"Oct",@11:@"Nov",@12:@"Dec"};
    NSString *string = [NSString stringWithFormat:@"%@ %ld, %ld",en_mouthDic[@(month)],day,year];
    return string;
}

@end


