//
//  MGSegmentView.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGSegmentView : UIView


@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) RACCommand *didSelectedTitle;


@end
