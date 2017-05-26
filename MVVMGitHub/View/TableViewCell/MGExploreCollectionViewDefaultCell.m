//
//  MGExploreCollectionViewDefaultCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/19.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreCollectionViewDefaultCell.h"

@interface MGExploreCollectionViewDefaultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MGExploreCollectionViewDefaultCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)bindViewModel:(id)viewModel{
    
    OCTUser *user = viewModel;
    [self.imageView sd_setImageWithURL:user.avatarURL placeholderImage:nil];
}

@end
