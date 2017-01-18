//
//  MGShowcasesModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/18.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGShowcasesModel.h"

@implementation MGShowcasesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"des":@"description"};
}
@end
