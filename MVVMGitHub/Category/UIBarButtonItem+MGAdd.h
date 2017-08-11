//
//  UIBarButtonItem+MGAdd.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MGBarButtonItemActionBlock)();

@interface UIBarButtonItem (MGAdd)


+ (instancetype)barButtonItemForPopViewController;


+ (instancetype)barButtonItemWithImage:(NSString *)imageName actionBlock:(MGBarButtonItemActionBlock)block;


@end
