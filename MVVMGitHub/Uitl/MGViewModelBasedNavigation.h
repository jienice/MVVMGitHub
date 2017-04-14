//
//  MGNavgationController.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGNavigationControllerProtocol.h"
#import "MGViewModelMapper.h"

@interface MGViewModelBasedNavigation : NSObject<MGNavigationControllerProtocol>

@property (nonatomic, strong, readonly) MGViewModelMapper *viewModelMapper;


- (void)resetRootNavigationController:(UINavigationController *)rootNavigationController;


@end
