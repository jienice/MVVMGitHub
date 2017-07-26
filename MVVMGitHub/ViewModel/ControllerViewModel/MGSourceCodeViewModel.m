//
//  MGSourceCodeViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSourceCodeViewModel.h"
NSString *const kSourceCodeOfRepo = @"kSourceCodeOfRepo";
NSString *const kSourceCodeSHA = @"kSourceCodeSHA";
NSString *const kSourceCodeFileName = @"kSourceCodeFileName";

@interface MGSourceCodeViewModel  ()

@property (nonatomic, strong, readwrite) RACCommand *fetchSourceCodeCommand;


@end


@implementation MGSourceCodeViewModel

- (void)initialize{
    
    @weakify(self);
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"codeview" ofType:@".html" inDirectory:@"codeMirror"];
    self.fileURL = [NSURL fileURLWithPath:htmlPath];
    
    self.fileName = self.params[kSourceCodeFileName];
    self.fetchSourceCodeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[[MGSharedDelegate.client fetchBlob:self.params[kSourceCodeSHA] inRepository:self.params[kSourceCodeOfRepo]] map:^id(NSData *data) {
            return [data utf8String];
        }] deliverOn:RACScheduler.mainThreadScheduler] takeUntil:self.rac_willDeallocSignal] doNext:^(NSString *utf8String) {
            @strongify(self);
            self.UTF8String = utf8String;
        }];
    }];
    
    
}

@end
