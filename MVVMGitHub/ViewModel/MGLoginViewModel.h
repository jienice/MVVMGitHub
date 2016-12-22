//
//  MGLoginViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@interface MGLoginViewModel : MGViewModel<MGViewModelProtocol>

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *passWord;

@property (nonatomic, strong, readonly) RACSignal *canLoginSignal;

@property (nonatomic, strong, readonly) RACCommand *loginCommand;


@end
