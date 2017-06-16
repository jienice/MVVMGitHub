//
//  UITableView+MGAdd.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/8.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTableViewBinder.h"

typedef void (^UITableViewCreateBlock)(MGTableViewBinder *binder);

@interface UITableView (MGAdd)

@property (nonatomic, strong) MGTableViewBinder *binder;


+ (instancetype)createTableWithFrame:(CGRect)frame binder:(UITableViewCreateBlock)tableViewCreateBlock;

+ (instancetype)createTableWithBinder:(UITableViewCreateBlock)tableViewCreateBlock;

- (void)headerEndRefresh;

- (void)footerEndRefresh;

- (void)footerEndRefreshWithNoMoreData;

- (void)endRefresh;

@end
