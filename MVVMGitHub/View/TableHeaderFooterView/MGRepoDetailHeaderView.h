//
//  MGRepoDetailHeaderView.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/20.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGRepositoriesModel;

@interface MGRepoDetailHeaderView : UIView<MGReactiveViewProtocol>

@property (nonatomic, strong) RACCommand *nameLabelClickedCommand;

@property (nonatomic, strong) RACCommand *didEndLayoutCommand;

@property (nonatomic, strong) RACCommand *changeBranchCommand;

@property (nonatomic, strong) RACCommand *branchClickedCommand;

@end
