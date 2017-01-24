//
//  MGRepoDetailViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailViewController.h"
#import "MGRepoDetailViewModel.h"
#import "MGRepositoriesModel.h"

@interface MGRepoDetailViewController ()

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
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


@end

@implementation MGRepoDetailViewController
#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepoDetailViewModel *)viewModel;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
}
- (void)configUI{
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.owerImageIcon];
    [self.contentView addSubview:self.createTimeLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.latestUpdateLabel];
    [self.contentView addSubview:self.nameButton];
    [self.contentView addSubview:self.watchButton];
    [self.contentView addSubview:self.starButton];
    [self.contentView addSubview:self.forkButton];
    [self.contentView addSubview:self.defaultBranchButton];
    self.canLayout = YES;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)bindViewModel{}

- (void)updateViewConstraints{
    
    if (self.canLayout) {
        [self.scrollView autoPinEdgesToSuperviewEdges];
        [self.contentView autoPinEdgesToSuperviewEdges];
        [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
        
        
    }
    [super updateViewConstraints];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UIScrollView *)scrollView{
    
    if (_scrollView==nil) {
        _scrollView= [UIScrollView new];
    }
    return _scrollView;
}
- (UIView *)contentView{
    
    if (_contentView==nil) {
        _contentView = [UIView new];
    }
    return _contentView;
}
- (UIImageView *)owerImageIcon{
    
    if (_owerImageIcon==nil) {
        _owerImageIcon = [UIImageView new];
        [_owerImageIcon sd_setImageWithURL:[NSURL URLWithString:self.viewModel.repo.owner.avatar_url]
                          placeholderImage:nil];
    }
    return _owerImageIcon;
}
- (UILabel *)createTimeLabel{
    
    if (_createTimeLabel==nil) {
        _createTimeLabel=[UILabel new];
        _createTimeLabel.text = self.viewModel.repo.created_at;
    }
    return _createTimeLabel;
}

- (UILabel *)descLabel{
    
    if (_descLabel==nil) {
        _descLabel=[UILabel new];
        _descLabel.text = self.viewModel.repo.des;
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
        [_nameButton setTitle:self.viewModel.repo.full_name
                     forState:UIControlStateNormal];
    }
    return _nameButton;
}
- (UIButton *)watchButton{
    
    if (_watchButton==nil) {
        _watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_watchButton setTitle:[self.viewModel.repo.watchers_count stringValue]
                      forState:UIControlStateNormal];
    }
    return _watchButton;
}
- (UIButton *)starButton{
    
    if (_starButton==nil) {
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setTitle:[self.viewModel.repo.stargazers_count stringValue]
                     forState:UIControlStateNormal];

    }
    return _starButton;
}
- (UIButton *)forkButton{
    
    if (_forkButton==nil) {
        _forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forkButton setTitle:[self.viewModel.repo.forks_count stringValue]
                     forState:UIControlStateNormal];
    }
    return _forkButton;
}
- (UIButton *)defaultBranchButton{
    
    if (_defaultBranchButton==nil) {
        _defaultBranchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultBranchButton setTitle:self.viewModel.repo.default_branch
                              forState:UIControlStateNormal];
    }
    return _defaultBranchButton;
}

@end
