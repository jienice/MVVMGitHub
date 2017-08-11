//
//  NSString+MGAdd.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/15.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MGAdd)

- (BOOL)isExist;

- (NSString *)readMeHtmlString;

+ (NSString *)onlyYearMouthDayDateStringForCommitDate:(NSDate *)date;
@end
