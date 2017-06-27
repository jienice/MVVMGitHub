//
//  MGExploreCollectionViewCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/19.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreCollectionViewCell.h"
#import "MGRepositoriesModel.h"

@interface MGExploreCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MGExploreCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    MGViewCornerRadius(self.imageView, 10);
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.borderWidth = 0.5;
}

- (void)bindViewModel:(id)viewModel{
    
    if ([viewModel isKindOfClass:[MGRepositoriesModel class]]) {
        MGRepositoriesModel *repo = viewModel;
        self.nameLabel.text = repo.name;
        [self.imageView sd_setImageWithURL:repo.owner.avatarURL placeholderImage:nil];
    }else if([viewModel isKindOfClass:[OCTUser class]]){
        OCTUser *user = viewModel;
        self.nameLabel.text = user.name;
        [self.imageView sd_setImageWithURL:user.avatarURL placeholderImage:nil];
    }
    
}

+ (CGSize)itemSize{
    
    return CGSizeMake(65, 110);
}
@end
