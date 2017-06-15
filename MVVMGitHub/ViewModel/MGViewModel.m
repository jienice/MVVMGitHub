//
//  MGViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@interface MGViewModel ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSDictionary *params;

@end

//ingore method not impl at protocol
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation MGViewModel
#pragma clang diagnostic pop


#pragma mark - Instancetype
- (instancetype)initWithParams:(NSDictionary *)params{
    
    if (self = [super init]) {
        self.params = params;
    }
    return self;
}

#pragma mark - setter
- (void)setParams:(NSDictionary *)params{
    
    _params = params;
    self.title = [params valueForKey:kNavigationTitle];
}

#pragma mark - Dealloc
- (void)dealloc{
    
    NSLog(@"%s",__func__);
}
@end
