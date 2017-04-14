//
//  MGOCTTreeEntryCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGOCTTreeEntryCell.h"

@interface MGOCTTreeEntryCell()


@property (weak, nonatomic) IBOutlet UILabel *treeEntryDesLabel;

@end

@implementation MGOCTTreeEntryCell

+ (instancetype)configOCTTreeCellWithTableView:(UITableView *)tableView treeEntry:(OCTTreeEntry *)treeEntry{
    
    MGOCTTreeEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGOCTTreeEntryCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MGOCTTreeEntryCell" owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    cell.treeEntryDesLabel.text = treeEntry.path;
    return cell;
}
@end
