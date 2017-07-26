//
//  MGSourceCodeViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

extern NSString *const kSourceCodeOfRepo;
extern NSString *const kSourceCodeSHA;
extern NSString *const kSourceCodeFileName;


@interface MGSourceCodeViewModel : MGViewModel<MGViewModelProtocol>

@property (nonatomic, copy) NSString *UTF8String;
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, strong, readonly) RACCommand *fetchSourceCodeCommand;

@property (nonatomic, strong) NSURL *fileURL;


@end
