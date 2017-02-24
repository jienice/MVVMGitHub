//
//  MGExploreViewController.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGExploreViewModel;
@interface MGExploreViewController : UIViewController<MGViewControllerProtocol>

@property (nonatomic, strong, readonly) MGExploreViewModel *viewModel;


@end
