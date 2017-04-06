//
//  MGUserDetailHeaderView.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGUserDetailHeaderView : UIView

@property (nonatomic, assign, readonly) CGFloat height;


- (instancetype)initWithUser:(OCTUser *)user;


@end
