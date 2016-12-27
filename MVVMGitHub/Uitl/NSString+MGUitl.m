//
//  NSString+MGUitl.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "NSString+MGUitl.h"

@implementation NSString (MGUitl)


- (BOOL)isExist{
    
    return self&&![self isKindOfClass:[NSNull class]]&&![self isEqualToString:@""];
}

@end
