//
//  MGRepoCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/28.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRepoCell : UITableViewCell<MGReactiveViewProtocol>

@property (nonatomic, strong, readonly) MGRepositoriesModel *repository;

+ (CGFloat)cellHeightWithViewModel:(id)viewModel;

@end
