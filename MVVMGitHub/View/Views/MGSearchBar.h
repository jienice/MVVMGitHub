//
//  MGSearchBar.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGSearchBar : UIView


@property (nonatomic, strong, readonly) RACSignal *searchTextSignal;

@property (nonatomic, strong, readonly) RACSignal *becomeFirstResponder;

@property (nonatomic, strong, readonly) RACSignal *resignFirstResponder;

@property (nonatomic, strong, readonly) RACSignal *didClickedSearchBtn;

@property (nonatomic, strong, readonly) RACCommand *startInputCommand;

+ (instancetype)showWithFrame:(CGRect)frame;



@end
