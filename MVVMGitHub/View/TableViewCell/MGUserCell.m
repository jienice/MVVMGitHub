//
//  MGUserCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGUserCell.h"


@interface MGUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end

@implementation MGUserCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)bindViewModel:(id)viewModel{
    
    NSParameterAssert([viewModel isKindOfClass:[OCTUser class]]);
    OCTUser *user = viewModel;
    [self.logoImageView sd_setImageWithURL:user.avatarURL placeholderImage:nil];
    self.userNameLabel.text = user.name;    
}

+ (CGFloat)cellHeight{
    
    return 60;
}
@end
