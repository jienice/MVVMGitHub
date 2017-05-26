//
//  MGRepositoriesCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRepositoriesCell : UITableViewCell<MGReactiveViewProtocol>

@property (nonatomic, strong, readonly) MGRepositoriesModel *repository;

+ (CGFloat)cellHeight;
@end
