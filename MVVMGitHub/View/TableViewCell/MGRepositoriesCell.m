//
//  MGRepositoriesCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/27.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoriesCell.h"

@interface MGRepositoriesCell ()

@property (nonatomic, strong, readwrite) MGRepositoriesModel *repository;
@property (nonatomic, strong) UILabel *repoDescriptionLabel;
@property (nonatomic, strong) UILabel *repoTitleLabel;
@property (nonatomic, strong) UILabel *languageKindLable;
@property (nonatomic, strong) UILabel *starCountLabel;
@property (nonatomic, strong) UILabel *forkCountLabel;
@property (nonatomic, strong) UIImageView *starImage;
@property (nonatomic, strong) UIImageView *forkImage;
@property (nonatomic, strong) UIImageView *repoKindImage;
@property (nonatomic, assign) BOOL isContainDesc;

@end


@implementation MGRepositoriesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = MGWhiteColor;
        [self.contentView addSubview:self.repoDescriptionLabel];
        [self.contentView addSubview:self.repoTitleLabel];
        [self.contentView addSubview:self.languageKindLable];
        [self.contentView addSubview:self.starImage];
        [self.contentView addSubview:self.forkImage];
        [self.contentView addSubview:self.repoKindImage];
        [self.contentView addSubview:self.starCountLabel];
        [self.contentView addSubview:self.forkCountLabel];
    }
    return self;
}

- (void)bindViewModel:(id)viewModel{
    
    self.repository = viewModel;
    self.isContainDesc = self.repository.repoDescription.isExist;
    self.repoTitleLabel.text = self.repository.SSHURL;
    self.repoDescriptionLabel.text = self.repository.repoDescription;
    self.languageKindLable.text = @"所属语言";
    self.repoKindImage.image = self.repository.isFork?[UIImage imageNamed:@"fork"]:[UIImage imageNamed:@"repo"];
}
- (void)layoutSubviews{
    
    [self.repoKindImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 5, 0) excludingEdge:ALEdgeRight];
    [self.repoKindImage autoSetDimension:ALDimensionWidth toSize:30];
    [self.repoKindImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.repoTitleLabel];
    [self.repoKindImage autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.repoTitleLabel];
    [self.repoTitleLabel autoSetDimension:ALDimensionHeight toSize:30];
    [self.repoTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-5];
    if (self.isContainDesc) {
        [self.repoDescriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.repoTitleLabel];
        [self.repoDescriptionLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.repoTitleLabel];
        [self.repoDescriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.repoTitleLabel];
        [self.repoDescriptionLabel autoSetDimension:ALDimensionHeight toSize:20];
        [self.languageKindLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.repoDescriptionLabel];
    }else{
        [self.languageKindLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.repoTitleLabel];
    }
    [self.languageKindLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.repoTitleLabel];
    [self.languageKindLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
    
    [self.languageKindLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.starImage];
    
    [self.starImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.languageKindLable];
    [self.starImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.languageKindLable];
    [self.starImage autoSetDimension:ALDimensionWidth toSize:15];
    
    [self.starImage autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.starCountLabel];
    [self.starCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.languageKindLable];
    [self.starCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.languageKindLable];
    
    [self.forkImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.languageKindLable];
    [self.forkImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.languageKindLable];
    [self.forkImage autoSetDimension:ALDimensionWidth toSize:15];
    [self.forkImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.starCountLabel];
    [self.forkCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.languageKindLable];
    [self.forkCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.languageKindLable];
    [self.forkCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.forkImage];

}

+ (CGFloat)cellHeight{
    
    return 75.f;
}
#pragma mark - Lazy Load
- (UILabel *)repoDescriptionLabel{
    
    if (_repoDescriptionLabel == nil) {
        _repoDescriptionLabel = [[UILabel alloc]init];
        _repoDescriptionLabel.font = MGFont(12);
        _repoDescriptionLabel.textColor = [UIColor blackColor];
    }
    return _repoDescriptionLabel;
}
- (UILabel *)repoTitleLabel{
    
    if (_repoTitleLabel == nil) {
        _repoTitleLabel = [[UILabel alloc]init];
        _repoTitleLabel.font = MGFont(13);
        _repoTitleLabel.textColor = [UIColor blueColor];
        
    }
    return _repoTitleLabel;
}
- (UILabel *)languageKindLable{
    
    if (_languageKindLable == nil) {
        _languageKindLable = [[UILabel alloc]init];
        _languageKindLable.font = MGFont(12);
        _languageKindLable.textColor = [UIColor blackColor];
    }
    return _languageKindLable;
}
- (UIImageView *)starImage{
    
    if (_starImage == nil) {
        _starImage = [[UIImageView alloc]init];
        _starImage.backgroundColor = [UIColor orangeColor];
    }
    return _starImage;
}
- (UIImageView *)forkImage{
    
    if (_forkImage == nil) {
        _forkImage = [[UIImageView alloc]init];
        _forkImage.image = [UIImage imageNamed:@"foke"];
        _forkImage.contentMode = UIViewContentModeCenter;
        _forkImage.backgroundColor = [UIColor greenColor];
    }
    return _forkImage;
}
- (UIImageView *)repoKindImage{
    
    if (_repoKindImage == nil) {
        _repoKindImage = [[UIImageView alloc]init];
        _repoKindImage.contentMode = UIViewContentModeCenter;
        _repoKindImage.backgroundColor = [UIColor redColor];
    }
    return _repoKindImage;
}
- (UILabel *)starCountLabel{
    
    if (_starCountLabel == nil) {
        _starCountLabel = [[UILabel alloc]init];
        _starCountLabel.font = MGFont(12);
        _starCountLabel.textColor = [UIColor blackColor];
        _starCountLabel.text = @"1";
    }
    return _starCountLabel;
}
- (UILabel *)forkCountLabel{
    
    if (_forkCountLabel == nil) {
        _forkCountLabel = [[UILabel alloc]init];
        _forkCountLabel.font = MGFont(12);
        _forkCountLabel.textColor = [UIColor blackColor];
        _forkCountLabel.text = @"1";
    }
    return _forkCountLabel;
}
@end
