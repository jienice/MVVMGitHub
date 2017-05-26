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
@property (weak, nonatomic) IBOutlet UILabel *repoDescLabel;

@end

@implementation MGExploreCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)bindViewModel:(id)viewModel{
    
    MGRepositoriesModel *repo = viewModel;
    self.repoDescLabel.text = repo.repoDescription;
    [self.imageView sd_setImageWithURL:repo.owner.avatarURL placeholderImage:nil];
}
@end
