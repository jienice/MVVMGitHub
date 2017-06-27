//
//  MGSearchViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchViewController.h"
#import "MGSearchViewModel.h"
#import "MGSearchRepoViewController.h"
#import "MGSearchUserViewController.h"
#import "MGSearchBar.h"


@interface MGSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) MGSearchViewModel *viewModel;
@property (nonatomic, strong) MGSearchRepoViewController *repoResult;
@property (nonatomic, strong) MGSearchUserViewController *userResult;
@property (nonatomic, strong) MGSearchBar *searchBar;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation MGSearchViewController


#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGSearchViewModel *)viewModel;
        self.menuBGColor = [UIColor whiteColor];
        self.automaticallyCalculatesItemWidths = YES;
        self.titleColorNormal = MGNormalColor;
        self.titleColorSelected = MGClickedColor;
        self.pageAnimatable = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressColor = MGClickedColor;
        self.progressHeight = 1;
        self.titleSizeSelected = 14;
        self.titleSizeNormal = 14;
        self.menuHeight = MGSEARCH_MENU_HEIGHT;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
    
    [self.searchBar.startInputCommand execute:@YES];
}
- (void)configUI{
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.maskView];
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [self.searchBar.searchTextSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        self.viewModel.searchText = x;
    }];
    
    [self.searchBar.didClickedSearchBtn subscribeNext:^(id x) {
        @strongify(self);
        switch (self.viewModel.searchType) {
            case MGSearchForUsers:{
                [self.viewModel.searchUserCommand execute:nil];
            }
                break;
            case MGSearchForRepositories:{
                [self.viewModel.searchRepoCommand execute:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    [self.searchBar.becomeFirstResponder subscribeNext:^(id x) {
        @strongify(self);
        [self.maskView setHidden:NO];
    }];
    
    [self.searchBar.resignFirstResponder subscribeNext:^(id x) {
        @strongify(self);
        [self.maskView setHidden:YES];
    }];
}
#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController
                titleAtIndex:(NSInteger)index{
    
    if (index==MGSearchForUsers) {
        return @"Users";
    }
    if (index == MGSearchForRepositories) {
        return @"Repositories";
    }
    return nil;
}
- (UIViewController *)pageController:(WMPageController *)pageController
               viewControllerAtIndex:(NSInteger)index{
    
    if (index==MGSearchForUsers) {
        return self.userResult;
    }
    if (index == MGSearchForRepositories) {
        return self.repoResult;
    }
    return nil;
}

- (void)pageController:(WMPageController *)pageController
didEnterViewController:(UIViewController *)viewController
              withInfo:(NSDictionary *)info{
    
    if (viewController==self.userResult) {
        self.viewModel.searchType = MGSearchForUsers;
    }else if (viewController==self.repoResult){
        self.viewModel.searchType = MGSearchForRepositories;
    }
}
#pragma mark - Lazy Load
- (MGSearchRepoViewController *)repoResult{
    
    if (_repoResult==nil) {
        _repoResult = [[MGSearchRepoViewController alloc]initWithViewModel:self.viewModel];
    }
    return _repoResult;
}
- (MGSearchUserViewController *)userResult{
    
    if (_userResult==nil) {
        _userResult = [[MGSearchUserViewController alloc]initWithViewModel:self.viewModel];
    }
    return _userResult;
}
- (MGSearchBar *)searchBar{
    
    if(_searchBar==nil){
        _searchBar = [MGSearchBar showWithFrame:CGRectMake(0, 0, MGSCREEN_WIDTH, MGNAV_STATUS_BAR_HEIGHT)];
    }
    return _searchBar;
}
- (UIView *)maskView {
    
	if(_maskView == nil) {
		_maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MGSCREEN_WIDTH, MGSCREEN_HEIGHT-MGNAV_STATUS_BAR_HEIGHT)];
        _maskView.alpha = 0.4;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.userInteractionEnabled=YES;
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [self.searchBar endEditing:YES];
        }];
        [_maskView addGestureRecognizer:tap];
	}
	return _maskView;
}

@end
