//
//  MGRepoCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/28.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoCell.h"

@interface MGRepoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *repoTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repoForkedCcountImage;
@property (weak, nonatomic) IBOutlet UIImageView *repoStaredCountImage;

@end

@implementation MGRepoCell{
    UIImage *_repoImage;
    UIImage *_repoForkedImage;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.repoForkedCcountImage.image =
    [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconRepoForked]
                   backgroundColor:MGWhiteColor
                         iconColor:[UIColor darkTextColor]
                         iconScale:1.0
                           andSize:self.repoForkedCcountImage.size];
    self.repoStaredCountImage.image =
    [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconStar]
                   backgroundColor:MGWhiteColor
                         iconColor:[UIColor darkTextColor]
                         iconScale:1.0
                           andSize:self.repoStaredCountImage.size];
    
    
    _repoImage = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconRepo]
                                backgroundColor:MGWhiteColor
                                      iconColor:MGHighlightedColor
                                      iconScale:1.0
                                        andSize:CGSizeMake(20, 20)];
    
    _repoForkedImage = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconRepoForked]
                                      backgroundColor:MGWhiteColor
                                            iconColor:MGHighlightedColor
                                            iconScale:1.0
                                              andSize:CGSizeMake(20, 20)];
    self.repoNameLabel.textColor = MGHighlightedColor;
}
- (void)bindViewModel:(id)viewModel{
    
    _repository = viewModel;
    self.repoNameLabel.text     = _repository.name;
    self.repoDescLabel.text     = _repository.repoDescription;
    self.repoLanguageLabel.text = _repository.language;
    self.repoTypeImage.image    = _repository.isFork?_repoForkedImage:_repoImage;
}

- (NSNumber *)cellHeightWithModel:(id)model{
    
    MGRepositoriesModel *repo = model;
    if (repo.repoDescription.isExist) {
        return @([self calculationRepoDescLabelHeight:repo.repoDescription]+(70-16));
    }else{
        return @(75-16-5-2);
    }
}

- (CGFloat)calculationRepoDescLabelHeight:(NSString *)repoDesc{
    
    CGRect contentFrame =
    [repoDesc boundingRectWithSize:CGSizeMake(MGSCREEN_WIDTH - 45, MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine
                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                           context:nil];
    return MIN(ceil(contentFrame.size.height), 16*2);//最多显示2行
}

@end
