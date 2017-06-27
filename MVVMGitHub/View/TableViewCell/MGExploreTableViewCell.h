//
//  MGExploreTableViewCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/5/25.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGExploreCellViewModel.h"

@interface MGExploreTableViewCell : UITableViewCell<MGReactiveViewProtocol>

@property (nonatomic, strong) MGExploreCellViewModel *cellViewModel;

@end
