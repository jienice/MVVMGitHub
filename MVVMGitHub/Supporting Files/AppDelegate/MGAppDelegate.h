//
//  AppDelegate.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGViewModelBasedNavigation.h"

@interface MGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) OCTClient *client;

@property (nonatomic, strong, readonly) MGViewModelBasedNavigation *viewModelBased;

@end

