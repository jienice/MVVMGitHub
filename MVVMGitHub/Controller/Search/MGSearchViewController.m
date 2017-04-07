//
//  MGSearchViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchViewController.h"
#import "MGSearchViewModel.h"

@interface MGSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MGSearchViewModel *viewModel;
@property (nonatomic, strong) HMSegmentedControl *segment;
@end

@implementation MGSearchViewController

#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGSearchViewModel *)viewModel;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
}
- (void)configUI{
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.segment];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)bindViewModel{

    @weakify(self);
    [[[self rac_signalForSelector:@selector(searchBar:textDidChange:)
                     fromProtocol:@protocol(UISearchBarDelegate)] distinctUntilChanged] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        NSLog(@"second--%@",tuple.second);
        self.viewModel.searchText = tuple.second;
    }];
}
- (void)updateViewConstraints{
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(MGSTATUS_BAR_HEIGHT);
        make.height.mas_equalTo(40);
    }];
    
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(1);
        make.height.mas_equalTo(40);
    }];
    [super updateViewConstraints];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UISearchBar *)searchBar{
    
    if (_searchBar==nil){
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        _searchBar.placeholder = @"Please input user's name or Repositories' name";
        _searchBar.delegate = self;
        _searchBar.tintColor = MGClickedColor;
    }
    return _searchBar;
}
- (HMSegmentedControl *)segment{
    
    if (_segment ==nil) {
        _segment = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"Users",@"Repositories"]];
        [_segment setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        [_segment setSelectionIndicatorColor:MGClickedColor];
        [_segment setSelectionIndicatorHeight:2];
        [_segment setTitleTextAttributes:@{NSFontAttributeName:MGFont(14),NSForegroundColorAttributeName:MGNormalColor}];
        [_segment setSelectedTitleTextAttributes:@{NSFontAttributeName:MGFont(14),NSForegroundColorAttributeName:MGClickedColor}];
        [_segment setIndexChangeBlock:^(NSInteger index) {
            
        }];
    }
    return _segment;
}
@end
