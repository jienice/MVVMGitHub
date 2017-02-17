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
<UITableViewDelegate,
UITableViewDataSource>

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

@property (nonatomic, strong) UITableView *fileListTable;

@property (nonatomic, strong) WKWebView *readmeWeb;
@end

@implementation MGRepoDetailViewController
#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepoDetailViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self.viewModel.fetchDataFromServiceCommand execute:nil];
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
    [self.contentView addSubview:self.fileListTable];
    [self.contentView addSubview:self.readmeWeb];
    self.canLayout = YES;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)bindViewModel{}

- (void)updateViewConstraints{
    
    if (self.canLayout) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.width.mas_equalTo(self.scrollView.mas_width);
            make.bottom.mas_equalTo(self.readmeWeb.mas_bottom).offset(-10);
        }];        
        
        [self.owerImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 60));
        }];
        
        [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.owerImageIcon.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
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
            make.top.mas_equalTo(self.owerImageIcon.mas_bottom).offset(10);
        }];
        
        [self.watchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@[self.starButton.mas_width,self.forkButton.mas_width]);
            make.height.mas_equalTo(@[@40,self.starButton.mas_height,self.forkButton.mas_height]);
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(5);
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
            make.top.mas_equalTo(self.forkButton.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
        
        [self.latestUpdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.defaultBranchButton.mas_top);
            make.bottom.mas_equalTo(self.defaultBranchButton.mas_bottom);
            make.right.mas_equalTo(self.nameButton.mas_right);
            make.left.mas_equalTo(self.defaultBranchButton.mas_right);
        }];
        
        [self.fileListTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.defaultBranchButton.mas_bottom).offset(10);
            make.right.mas_equalTo(self.nameButton.mas_right);
            make.left.mas_equalTo(self.owerImageIcon.mas_left);
            make.height.mas_equalTo(300);
        }];
        
        [self.readmeWeb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fileListTable.mas_bottom).offset(10);
            make.right.mas_equalTo(self.nameButton.mas_right);
            make.left.mas_equalTo(self.owerImageIcon.mas_left);
            make.height.mas_equalTo(300);
        }];
    }
    [super updateViewConstraints];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.fileTree.entries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
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
        [_nameButton setTitle:self.viewModel.repo.full_name
                     forState:UIControlStateNormal];
    }
    return _nameButton;
}
- (UIButton *)watchButton{
    
    if (_watchButton==nil) {
        _watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_watchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_watchButton setTitle:[self.viewModel.repo.watchers_count stringValue]
                      forState:UIControlStateNormal];
    }
    return _watchButton;
}
- (UIButton *)starButton{
    
    if (_starButton==nil) {
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_starButton setTitle:[self.viewModel.repo.stargazers_count stringValue]
                     forState:UIControlStateNormal];

    }
    return _starButton;
}
- (UIButton *)forkButton{
    
    if (_forkButton==nil) {
        _forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_forkButton setTitle:[self.viewModel.repo.forks_count stringValue]
                     forState:UIControlStateNormal];
    }
    return _forkButton;
}
- (UIButton *)defaultBranchButton{
    
    if (_defaultBranchButton==nil) {
        _defaultBranchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultBranchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_defaultBranchButton setTitle:self.viewModel.repo.default_branch
                              forState:UIControlStateNormal];
        @weakify(self);
        [[_defaultBranchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel.fetchRepoBranchsCommand execute:nil];
        }];
    }
    return _defaultBranchButton;
}
- (UITableView *)fileListTable{
    
    if (_fileListTable==nil) {
        _fileListTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _fileListTable.backgroundColor = [UIColor redColor];
    }
    return _fileListTable;
}
- (WKWebView *)readmeWeb{
    
    if(_readmeWeb==nil){
        _readmeWeb = [[WKWebView alloc]initWithFrame:CGRectZero];
        _readmeWeb.backgroundColor = [UIColor redColor];
    }
    return _readmeWeb;
}
@end
