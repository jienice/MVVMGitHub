//
//  MGServiceimp.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGServiceimp.h"

@implementation MGServiceimp

@synthesize client = _client;




- (void)setClient:(OCTClient *)client{
    
    _client = client;
}
- (OCTClient *)client{
    
    return _client;
}
@end
