//
//  MGExploreCollectionViewCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/19.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreCollectionViewCell.h"

@interface MGExploreCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MGExploreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 15;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = MGNormalColor.CGColor;
    self.imageView.layer.borderWidth = 0.3f;
}

- (void)bindViewModel:(id)viewModel{
    NSURL *imageURL;
    if ([viewModel isKindOfClass:[MGRepositoriesModel class]]) {
        MGRepositoriesModel *repo = viewModel;
        self.nameLabel.text = repo.name;
        imageURL = repo.owner.avatarURL;
    }else if([viewModel isKindOfClass:[OCTUser class]]){
        OCTUser *user = viewModel;
        self.nameLabel.text = user.name;
        imageURL = user.avatarURL;
    }
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:MGNormalColor]];
}

+ (CGSize)itemSize{
    return CGSizeMake(65, 110);
}
@end
