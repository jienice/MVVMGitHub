//
//  MGProfileHeaderView.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,MGProfileCategoryType){
    MGProfileCategoryTypeOfPublicRepo,
    MGProfileCategoryTypeOfFollower,
    MGProfileCategoryTypeOfFollowing
};


@interface MGProfileHeaderView : UIView<MGReactiveViewProtocol>

@property (nonatomic, strong) RACCommand *didClickedCategoryCommand;

@end
