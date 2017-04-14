//
//  MGViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGViewModel : NSObject<MGViewModelProtocol>

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, strong, readonly) NSDictionary *params;

@property (nonatomic, strong) RACSubject *error;

@end
