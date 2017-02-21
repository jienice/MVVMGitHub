//
//  MGRepoDetailHeaderView.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/20.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailHeaderView.h"
#import "MGRepositoriesModel.h"

#define LINE_SPACE 5

@interface MGRepoDetailHeaderView ()

@property (nonatomic, strong) UIImageView *owerImageIcon;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *latestUpdateLabel;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIButton *watchButton;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@property (nonatomic, strong) UIButton *defaultBranchButton;

@property (nonatomic, assign) BOOL canLayout;

@property (nonatomic, assign, readwrite) CGFloat height;

@end

@implementation MGRepoDetailHeaderView

- (instancetype)initHeaderViewWithRepo:(MGRepositoriesModel *)repo{
    
    MGRepoDetailHeaderView *headerView = [[MGRepoDetailHeaderView alloc]init];
    [headerView addSubview:headerView.owerImageIcon];
    [headerView addSubview:headerView.createTimeLabel];
    [headerView addSubview:headerView.descLabel];
    [headerView addSubview:headerView.latestUpdateLabel];
    [headerView addSubview:headerView.nameButton];
    [headerView addSubview:headerView.watchButton];
    [headerView addSubview:headerView.starButton];
    [headerView addSubview:headerView.forkButton];
    [headerView addSubview:headerView.defaultBranchButton];
    headerView.canLayout = YES;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    [headerView setRepo:repo];
    return headerView;
}

- (void)layoutSubviews{
    
    if (self.canLayout) {
        [self.owerImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.top.mas_equalTo(self.mas_top).offset(LINE_SPACE);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.owerImageIcon.mas_top);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.left.mas_equalTo(self.owerImageIcon.mas_right).offset(5);
            make.height.mas_equalTo(self.createTimeLabel.mas_height);
        }];
        
        [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameButton.mas_left);
            make.right.mas_equalTo(self.nameButton.mas_right);
            make.top.mas_equalTo(self.nameButton.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.owerImageIcon.mas_bottom);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.owerImageIcon.mas_left);
            make.right.mas_equalTo(self.nameButton.mas_right);
            make.top.mas_equalTo(self.owerImageIcon.mas_bottom).offset(LINE_SPACE);
        }];
        
        [self.watchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@[self.starButton.mas_width,self.forkButton.mas_width]);
            make.height.mas_equalTo(@[@40,self.starButton.mas_height,self.forkButton.mas_height]);
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(LINE_SPACE);
            make.right.mas_equalTo(self.starButton.mas_left).offset(-5);
            make.left.mas_equalTo(self.owerImageIcon.mas_left);
        }];
        
        [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@[self.watchButton.mas_top,self.forkButton.mas_top]);
            make.right.mas_equalTo(self.forkButton.mas_left).offset(-5);
        }];
        
        [self.forkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.nameButton.mas_right);
        }];
        
        [self.defaultBranchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.owerImageIcon.mas_left);
            make.top.mas_equalTo(self.forkButton.mas_bottom).offset(LINE_SPACE);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
        
        [self.latestUpdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.defaultBranchButton.mas_top);
            make.bottom.mas_equalTo(self.defaultBranchButton.mas_bottom);
            make.right.mas_equalTo(self.nameButton.mas_right);
            make.left.mas_equalTo(self.defaultBranchButton.mas_right);
        }];
    }
    [super layoutSubviews];
}
#pragma mark - setter
- (void)setRepo:(MGRepositoriesModel *)repo{
    
    [self.owerImageIcon sd_setImageWithURL:[NSURL URLWithString:repo.owner.avatar_url]
                                placeholderImage:nil];
    self.createTimeLabel.text = repo.created_at;
    self.descLabel.text = repo.des;
    [self.nameButton setTitle:repo.full_name
                     forState:UIControlStateNormal];
    [self.watchButton setTitle:[repo.watchers_count stringValue]
                      forState:UIControlStateNormal];
    [self.starButton setTitle:[repo.stargazers_count stringValue]
                     forState:UIControlStateNormal];
    [self.forkButton setTitle:[repo.forks_count stringValue]
                     forState:UIControlStateNormal];
    [self.defaultBranchButton setTitle:repo.default_branch
                              forState:UIControlStateNormal];
}
- (void)setNameBtnClickedCommand:(RACCommand *)nameBtnClickedCommand{
    
    _nameBtnClickedCommand = nameBtnClickedCommand;
    self.nameButton.rac_command = _nameBtnClickedCommand;
}
- (void)setWatchBtnClickedCommand:(RACCommand *)watchBtnClickedCommand{
    
    _watchBtnClickedCommand=watchBtnClickedCommand;
    self.watchButton.rac_command = _watchBtnClickedCommand;
}
- (void)setStarBtnClickedCommand:(RACCommand *)starBtnClickedCommand{
    
    _starBtnClickedCommand = starBtnClickedCommand;
    self.starButton.rac_command = _starBtnClickedCommand;
}
- (void)setForkBtnClickedCommand:(RACCommand *)forkBtnClickedCommand{
    
    _forkBtnClickedCommand = forkBtnClickedCommand;
    self.forkButton.rac_command = _forkBtnClickedCommand;
}
- (void)setBranchBtnClickedCommand:(RACCommand *)branchBtnClickedCommand{
    
    _branchBtnClickedCommand = branchBtnClickedCommand;
    self.defaultBranchButton.rac_command = _branchBtnClickedCommand;
}
#pragma mark -getter
- (CGFloat)height{
    
    CGRect contentFrame = [self.descLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.descLabel.frame), MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                         attributes:@{NSFontAttributeName:self.descLabel.font}
                                                            context:nil];
    CGFloat descHeight = contentFrame.size.height + 30;
    return LINE_SPACE+60+LINE_SPACE+descHeight+LINE_SPACE+40+LINE_SPACE+50;
}
#pragma mark - lazy load
- (UIImageView *)owerImageIcon{
    
    if (_owerImageIcon==nil) {
        _owerImageIcon = [UIImageView new];
    }
    return _owerImageIcon;
}
- (UILabel *)createTimeLabel{
    
    if (_createTimeLabel==nil) {
        _createTimeLabel=[UILabel new];
    }
    return _createTimeLabel;
}

- (UILabel *)descLabel{
    
    if (_descLabel==nil) {
        _descLabel=[UILabel new];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
- (UILabel *)latestUpdateLabel{
    
    if (_latestUpdateLabel==nil) {
        _latestUpdateLabel=[UILabel new];
    }
    return _latestUpdateLabel;
}
- (UIButton *)nameButton{
    
    if (_nameButton==nil) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _nameButton;
}
- (UIButton *)watchButton{
    
    if (_watchButton==nil) {
        _watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_watchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _watchButton;
}
- (UIButton *)starButton{
    
    if (_starButton==nil) {
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _starButton;
}
- (UIButton *)forkButton{
    
    if (_forkButton==nil) {
        _forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _forkButton;
}
- (UIButton *)defaultBranchButton{
    
    if (_defaultBranchButton==nil) {
        _defaultBranchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultBranchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _defaultBranchButton;
}
@end
