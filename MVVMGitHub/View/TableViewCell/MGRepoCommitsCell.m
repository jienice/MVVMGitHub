//
//  MGRepoCommitsCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/16.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoCommitsCell.h"

@interface MGRepoCommitsCell ()

@property (weak, nonatomic) IBOutlet UILabel *commitDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *committerAndDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *committerImage;

@end


@implementation MGRepoCommitsCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}
- (void)bindViewModel:(id)viewModel{
    
    OCTGitCommit *commit = viewModel;
    self.commitDateLabel.text       = [NSString stringWithFormat:@"Commits on %@",commit.commitDate];
    self.commitMessageLabel.text    = commit.message;
    self.committerAndDateLabel.text = [NSString stringWithFormat:@"%@ committed on %@",commit.committerName,commit.commitDate];
    [self.committerImage sd_setImageWithURL:commit.committer.avatarURL placeholderImage:nil];
    
    [commit.message boundingRectWithSize:CGSizeMake(100 - 30, MAXFLOAT)
                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                              attributes:@{NSFontAttributeName:MGBlodFont(16)}
                                 context:nil];
}

+ (CGFloat)cellHeight{
    
    
    return 110;
}

@end
