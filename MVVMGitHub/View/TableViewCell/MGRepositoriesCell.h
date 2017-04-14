//
//  MGRepositoriesCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRepositoriesCell : UITableViewCell

+ (instancetype)configCellForTableView:(UITableView *)tableView
                            repository:(OCTRepository *)repository
                       reuseIdentifier:(NSString *)reuseIdentifier;


+ (CGFloat)cellHeight;
@end
