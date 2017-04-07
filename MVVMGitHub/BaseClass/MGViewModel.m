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

@end

@implementation MGViewModel

- (instancetype)initWithParams:(NSDictionary *)params{
    
    if (self = [super init]) {
        self.params = params;
        [self.error subscribeNext:^(NSError *error) {
            NSLog(@"MGViewModel.error %@",error);
        }];
    }
    return self;
}

- (RACSubject *)error{
    
    if (!_error) {
        return [RACSubject subject];
    }
    return _error;
}

- (void)setParams:(NSDictionary *)params{
    
    _params = params;
    self.title = [params valueForKey:kNavigationTitle];
}
@end
