//
//  MGViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"
#import "MGMainViewModel.h"


@interface MGViewModel ()

@property (nonatomic, copy, readwrite) NSString *title;

@end

@implementation MGViewModel

- (instancetype)initWithParams:(NSDictionary *)params{
    
    if (self = [super init]) {
        self.params = params;
        self.title = [params valueForKey:kNavigationTitle];
        if ([self conformsToProtocol:@protocol(MGViewModelProtocol)]&&
            [self respondsToSelector:@selector(initialize)]) {
            [self performSelector:@selector(initialize)];
        }
    }
    return self;
}


@end
