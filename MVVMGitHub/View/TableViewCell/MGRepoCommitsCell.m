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

@property (nonatomic, assign) CGFloat nibHeight;
@end


@implementation MGRepoCommitsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nibHeight = self.height;
}

- (void)bindViewModel:(id)viewModel{
    OCTGitCommit *commit = viewModel;
    NSString *commitString = [NSString onlyYearMouthDayDateStringForCommitDate:commit.commitDate];
    self.commitDateLabel.text       = [NSString stringWithFormat:@"Commits on %@",commitString];
    self.commitMessageLabel.text    = [self messageRewrite:commit.message];
    self.committerAndDateLabel.text = [NSString stringWithFormat:@"%@ committed on %@",commit.committerName,commitString];
    [self.committerImage sd_setImageWithURL:commit.author.avatarURL placeholderImage:nil];
}

- (NSNumber *)cellHeightWithModel:(id)model{
    OCTGitCommit *commit = model;
    NSString *showString = [self messageRewrite:commit.message];
    CGFloat height       = [showString heightForFont:self.commitMessageLabel.font
                                               width:self.commitMessageLabel.width];
    NSLog(@"%f %@",ceil(height),showString);
    return @(ceil(height)+(self.nibHeight-33.5));
}

- (NSString *)messageRewrite:(NSString *)message{
    NSMutableString *mutMessage = [NSMutableString stringWithString:message];
    [self removeLastLineBreak:mutMessage];
    [self removeDouleLineBreak:mutMessage];
    [mutMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    return mutMessage;
}
- (void)removeLastLineBreak:(NSMutableString *)string{
    if ([string hasSuffix:@"\n"]) {
        [string deleteCharactersInRange:NSMakeRange(string.length, 1)];
    }
}
- (void)removeDouleLineBreak:(NSMutableString *)string{
    if ([string containsString:@"\n\n"]){
        NSRange range = [string rangeOfString:@"\n\n"];
        [string replaceCharactersInRange:range withString:@"\n"];
        [self messageRewrite:string];
    }
}

@end
