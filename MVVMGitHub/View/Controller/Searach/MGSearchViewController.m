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

@end

@implementation MGSearchViewController


#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    if (self = [super init]) {
        self.viewModel = (MGSearchViewModel *)viewModel;
        self.menuBGColor = [UIColor whiteColor];
        self.automaticallyCalculatesItemWidths = YES;
        self.titleColorNormal = MGNormalColor;
        self.titleColorSelected = MGSystemColor;
        self.pageAnimatable = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressColor = MGSystemColor;
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
}

- (void)configUI{
    @weakify(self);
    self.navigationItem.titleView = ({
        @strongify(self);
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:self.navigationController.navigationBar.bounds];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.placeholder = kSearchBarPlaceholderString;
        searchBar.delegate = self;
        searchBar;
    });
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:nil action:nil];
    
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    @weakify(self);
    [[RACObserve(self, searchBar.searchText) ignore:@""] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.searchText = x;
    }];
    
    [self.searchBar.cancelSearchCommand.executionSignals subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self.searchBar.searchCommand.executionSignals subscribeNext:^(id x) {
        
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
        _searchBar = [MGSearchBar showWithFrame:CGRectMake(0, MGSTATUS_BAR_HEIGHT, MGSCREEN_WIDTH, MGNAV_BAR_HEIGHT)];
    }
    return _searchBar;
}
@end
