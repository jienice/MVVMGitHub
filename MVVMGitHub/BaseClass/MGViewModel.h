//
//  MGViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGViewModel : NSObject<MGViewModelProtocol>


@property (nonatomic, strong) id<MGServiceProtocol> service;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy, readonly) NSString *title;


@end
