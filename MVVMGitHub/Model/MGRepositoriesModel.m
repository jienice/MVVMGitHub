//
//  MGTrendRepoModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/18.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepositoriesModel.h"

@implementation MGRepositoriesModel

+ (NSValueTransformer *)ownerJSONTransformer {
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:OCTUser.class];
}


@end
