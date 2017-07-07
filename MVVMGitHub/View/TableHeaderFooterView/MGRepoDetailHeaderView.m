//
//  MGRepoDetailself.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/20.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailHeaderView.h"
#import "MGRepositoriesModel.h"

@interface MGRepoDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *repoOwnerImage;
@property (weak, nonatomic) IBOutlet UILabel *repoFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestUpdateTimeLabel;

@property (nonatomic, assign) CGFloat viewHeightAtNib;
@end

@implementation MGRepoDetailHeaderView{
    MGRepositoriesModel *_repo;
}

- (instancetype)init{
    
    MGRepoDetailHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MGRepoDetailHeaderView class])
                                                                 owner:self options:nil]
                                    firstObject];
    view.viewHeightAtNib = view.frame.size.height;
    return view;
}


- (void)bindViewModel:(id)viewModel{
    
    _repo = viewModel;
    self.repoCreateTimeLabel.text = _repo.created_at;
    self.repoDescLabel.text = _repo.repoDescription;
    self.latestUpdateTimeLabel.text = _repo.updated_at;

    [self.repoOwnerImage sd_setImageWithURL:_repo.owner.avatarURL placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.repoOwnerImage.image imageByRoundCornerRadius:5];
    }];
}
#pragma mark - setter
- (void)setNameLabelClickedCommand:(RACCommand *)nameLabelClickedCommand{
    
    _nameLabelClickedCommand = nameLabelClickedCommand;
}

#pragma mark -getter
- (CGFloat)height{
    
    if (_repo.repoDescription) {
        CGRect contentFrame = [self.repoDescLabel.text
                               boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.repoDescLabel.frame),
                                                               MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin|
                               NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName:MGFont(14)}
                               context:nil];
        return self.viewHeightAtNib+ceil(contentFrame.size.height);
    }
    return self.viewHeightAtNib-10;
}


@end
