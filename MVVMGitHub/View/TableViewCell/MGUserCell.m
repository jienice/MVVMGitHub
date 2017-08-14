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

@implementation MGUserCell{
    UIImage *_followImage;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _followImage = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconPersonAdd]
                                  backgroundColor:MGWhiteColor
                                        iconColor:MGSystemColor
                                        iconScale:1.0
                                          andSize:CGSizeMake(30, [[self cellHeightWithModel:nil] floatValue])];
}

- (void)bindViewModel:(id)viewModel{
    
    NSParameterAssert([viewModel isKindOfClass:[OCTUser class]]);
    OCTUser *user = viewModel;
    [self.logoImageView sd_setImageWithURL:user.avatarURL placeholderImage:nil];
    
    self.userNameLabel.text = user.name;
    [self.followBtn setImage:_followImage forState:UIControlStateNormal];
    [self.followBtn setImage:_followImage forState:UIControlStateHighlighted];
    [self.followBtn setImage:_followImage forState:UIControlStateSelected];
}
- (NSNumber *)cellHeightWithModel:(id)model{
    
    return @55;
}

@end
