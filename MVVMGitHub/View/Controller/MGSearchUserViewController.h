//
//  MGSearchUserViewController.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGSearchViewModel;
@interface MGSearchUserViewController : UITableViewController

@property (nonatomic, weak) MGSearchViewModel *viewModel;

@end
