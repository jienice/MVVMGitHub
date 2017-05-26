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

@interface MGSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) MGSearchViewModel *viewModel;
@property (nonatomic, strong) MGSearchRepoViewController *repoResult;
@property (nonatomic, strong) MGSearchUserViewController *userResult;
@property (nonatomic, strong) UISearchBar *searchBar;


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
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self bindViewModel:nil];
    
}

- (void)bindViewModel:(id)viewModel{
    
    
}
#pragma mark - Load Data

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
didEnterViewController:(UIViewController * )viewController
              withInfo:(NSDictionary *)info{
    
    if (viewController==self.userResult) {
        self.viewModel.searchType = MGSearchForUsers;
    }else if (viewController==self.repoResult){
        self.viewModel.searchType = MGSearchForRepositories;
    }
    [self.viewModel.searchCommand execute:nil];
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    self.viewModel.searchText = searchText;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
}
#pragma mark - Lazy Load
- (MGSearchRepoViewController *)repoResult{
    
    if (_repoResult==nil) {
        _repoResult = [[MGSearchRepoViewController alloc]initWithStyle:UITableViewStylePlain];
        _repoResult.viewModel = self.viewModel;
    }
    return _repoResult;
}
- (MGSearchUserViewController *)userResult{
    
    if (_userResult==nil) {
        _userResult = [[MGSearchUserViewController alloc]initWithStyle:UITableViewStylePlain];
        _userResult.viewModel = self.viewModel;
    }
    return _userResult;
}
- (UISearchBar *)searchBar{
    
    if(_searchBar==nil){
        _searchBar = [[UISearchBar alloc]initWithFrame:self.navigationController.navigationBar.bounds];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"Please Input Repo's Or User's Name";
        [_searchBar setTintColor:MGClickedColor];
    }
    return _searchBar;
}
@end
