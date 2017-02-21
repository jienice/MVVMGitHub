//
//  MGRepoDetailHeaderView.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/20.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGRepositoriesModel;
@interface MGRepoDetailHeaderView : UIView

@property (nonatomic, strong) RACCommand *nameBtnClickedCommand;
@property (nonatomic, strong) RACCommand *watchBtnClickedCommand;
@property (nonatomic, strong) RACCommand *starBtnClickedCommand;
@property (nonatomic, strong) RACCommand *forkBtnClickedCommand;
@property (nonatomic, strong) RACCommand *branchBtnClickedCommand;

@property (nonatomic, assign, readonly) CGFloat height;

- (instancetype)initHeaderViewWithRepo:(MGRepositoriesModel *)repo;


@end
