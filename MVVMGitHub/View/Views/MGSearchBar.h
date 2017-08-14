//
//  MGSearchBar.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGSearchBar : UIView

@property (nonatomic, strong, readonly) RACCommand *cancelSearchCommand;


@property (nonatomic, strong, readonly) RACCommand *searchCommand;

@property (nonatomic, copy, readonly) NSString *searchText;

+ (instancetype)showWithFrame:(CGRect)frame;



@end
