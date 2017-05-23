//
//  MGExploreCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGReactiveViewProtocol.h"

@class MGExploreCellViewModel;

@interface MGExploreCell : UITableViewCell<MGReactiveViewProtocol>

@property (nonatomic, strong, readonly) RACCommand *seeAllCommand;
@property (nonatomic, strong, readonly) RACCommand *didSelectedItemCommand;
@property (nonatomic, strong, readonly) MGExploreCellViewModel *rowViewModel;
@property (nonatomic, strong, readonly) NSArray *collectionDataSource;

+ (CGFloat)cellHeight;

@end
