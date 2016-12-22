//
//  MGError.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGError.h"


NSString *const MGErrorDomain = @"com.xingjie.mvvmgithub";

@implementation MGError

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo{
    
   return [MGError errorWithDomain:MGErrorDomain code:code userInfo:userInfo];
}

@end
