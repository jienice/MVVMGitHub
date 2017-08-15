//
//  MGSearchViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchViewController.h"
#import "MGSearchRepoViewController.h"
#import "MGSearchUserViewController.h"
#import "MGSearchViewModel.h"

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
        self.titleColorSelected = MGHighlightedColor;
        self.pageAnimatable = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressColor = MGHighlightedColor;
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)configUI{
    @weakify(self);
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"取消" titleFont:MGFont(14) titleColor:MGHighlightedColor actionBlock:^{
        @strongify(self);
        [RACScheduler.mainThreadScheduler schedule:^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }];
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    @weakify(self);
    Protocol *searchBarDelegate = @protocol(UISearchBarDelegate);
    [[self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:searchBarDelegate] subscribeNext:^(RACTuple *tuple) {
        NSLog(@"searchText --- %@",((UISearchBar *)[tuple first]).text);
        @strongify(self);
        self.viewModel.searchText = ((UISearchBar *)[tuple first]).text;
    }];
    
    [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:searchBarDelegate] subscribeNext:^(id x) {
        @strongify(self);
        [self.searchBar resignFirstResponder];
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
    
    [[[RACSignal combineLatest:@[self.viewModel.searchRepoCommand.executing,
                               self.viewModel.searchUserCommand.executing] reduce:^NSNumber *(NSNumber *repoExecut,NSNumber *userExecut){
                                   return @(repoExecut.boolValue|userExecut.boolValue);
    }] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSNumber *execut) {
        if (execut.boolValue) {
            [SVProgressHUD show];
        }else{
            [SVProgressHUD dismiss];
        }
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
    switch ((MGSearchType)index) {
        case MGSearchForUsers:
            return @"Users";
            break;
        case MGSearchForRepositories:
            return @"Repositories";
            break;
        default:
            return nil;
            break;
    }
}
- (UIViewController *)pageController:(WMPageController *)pageController
               viewControllerAtIndex:(NSInteger)index{
    switch ((MGSearchType)index) {
        case MGSearchForUsers:
            return self.userResult;
            break;
        case MGSearchForRepositories:
            return self.repoResult;
            break;
        default:
            return nil;
            break;
    }
}

- (void)pageController:(WMPageController *)pageController
didEnterViewController:(UIViewController *)viewController
              withInfo:(NSDictionary *)info{
    if (viewController==self.userResult) {
        self.searchBar.placeholder = @"Search Users";
        self.viewModel.searchType = MGSearchForUsers;
    }else if (viewController==self.repoResult){
        self.searchBar.placeholder = @"Search Repositories";
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

- (UISearchBar *)searchBar {
	if(_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:self.navigationController.navigationBar.bounds];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"Search";
        _searchBar.delegate = self;
        _searchBar.autocapitalizationType =UITextAutocapitalizationTypeNone;
    }
	return _searchBar;
}

@end
