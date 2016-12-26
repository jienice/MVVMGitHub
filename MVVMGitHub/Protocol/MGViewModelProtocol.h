//
//  MGViewModelProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGViewModelProtocol <NSObject>

- (instancetype)initWithParams:(NSDictionary *)params;


@optional

@property (nonatomic, strong) RACCommand *fetchDataFromServiceCommand;

- (void)initialize;

@end
