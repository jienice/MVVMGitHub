//
//  MGViewModelProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGServiceProtocol.h"

@protocol MGViewModelProtocol <NSObject>

- (instancetype)initWithService:(id<MGServiceProtocol>)service params:(NSDictionary *)params;


@optional
- (void)initialize;

@end
