//
//  MGTrendRepoModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/18.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepositoriesModel.h"

@implementation MGRepositoriesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id",
             @"des":@"description",
             @"isPrivate":@"private"};
}

@end
