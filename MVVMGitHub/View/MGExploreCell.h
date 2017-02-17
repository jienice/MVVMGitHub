//
//  MGExploreCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGExploreRowViewModel;

@interface MGExploreCell : UITableViewCell

@property (nonatomic, strong) RACCommand *seeAllCommand;

@property (nonatomic, strong) RACCommand *didSelectedItemCommand;

@property (nonatomic, copy, readonly) NSString *titleString;

@property (nonatomic, strong, readonly) NSArray *collectionDataSource;

@property (nonatomic, strong, readonly) MGExploreRowViewModel *rowViewModel;


+ (instancetype)configExploreCell:(UITableView *)tableView
                  reuseIdentifier:(NSString *)reuseIdentifier
                     rowViewModel:(MGExploreRowViewModel *)rowViewModel;


+ (CGFloat)cellHeight;

@end
