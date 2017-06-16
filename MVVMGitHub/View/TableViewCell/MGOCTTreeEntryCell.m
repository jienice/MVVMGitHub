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


- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bindViewModel:(id)viewModel{
    
    OCTTreeEntry *treeEntry = viewModel;
    self.treeEntryDesLabel.text = treeEntry.path;
}
@end
