//
//  MGExploreViewController.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewController.h"
#import "MGViewControllerProtocol.h"

@class MGExploreViewModel;

@interface MGExploreViewController : MGViewController <MGViewControllerProtocol>

@property (nonatomic, weak, readonly) MGExploreViewModel *viewModel;


@end
