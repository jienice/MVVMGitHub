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
}

- (void)bindViewModel:(id)viewModel{
    
    CGFloat cornerRadius = 30;
    @weakify(self);
    if ([viewModel isKindOfClass:[MGRepositoriesModel class]]) {
        MGRepositoriesModel *repo = viewModel;
        self.nameLabel.text = repo.name;
        [self.imageView sd_setImageWithURL:repo.owner.avatarURL placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            @strongify(self);
            self.imageView.image = [image imageByRoundCornerRadius:cornerRadius
                                                       borderWidth:1
                                                       borderColor:[UIColor lightGrayColor]];
        }];
    }else if([viewModel isKindOfClass:[OCTUser class]]){
        OCTUser *user = viewModel;
        self.nameLabel.text = user.name;
        [self.imageView sd_setImageWithURL:user.avatarURL placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            @strongify(self);
            self.imageView.image = [image imageByRoundCornerRadius:cornerRadius
                                                       borderWidth:1
                                                       borderColor:[UIColor lightGrayColor]];
        }];
    }
}

+ (CGSize)itemSize{
    
    return CGSizeMake(65, 110);
}
@end
