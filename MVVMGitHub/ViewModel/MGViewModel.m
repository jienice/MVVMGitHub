//
//  MGViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@interface MGViewModel ()


@end

//ingore method not impl at protocol
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation MGViewModel
#pragma clang diagnostic pop


#pragma mark - Instancetype
- (instancetype)initWithParams:(NSDictionary *)params{
    
    if (self = [super init]) {
        _params = params;
    }
    return self;
}


#pragma mark - Dealloc
- (void)dealloc{
    
    NSLog(@"%s",__func__);
}
@end
