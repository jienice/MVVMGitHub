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
    
    CGFloat cornerRadius = 60;
    NSURL *imageURL;
    @weakify(self);
    if ([viewModel isKindOfClass:[MGRepositoriesModel class]]) {
        MGRepositoriesModel *repo = viewModel;
        self.nameLabel.text = repo.name;
        imageURL = repo.owner.avatarURL;
    }else if([viewModel isKindOfClass:[OCTUser class]]){
        OCTUser *user = viewModel;
        self.nameLabel.text = user.name;
        imageURL = user.avatarURL;
    }
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                 @strongify(self);
                                 self.imageView.image = [image imageByRoundCornerRadius:cornerRadius];
                             }];
    
}

+ (CGSize)itemSize{
    
    return CGSizeMake(65, 110);
}
@end
