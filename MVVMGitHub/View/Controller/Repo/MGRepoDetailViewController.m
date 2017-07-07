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
#import "MGRepoDetailHeaderView.h"
#import "MGOCTTreeEntryCell.h"
#import "WKWebView+MGWeb.h"
#import "MGRepoCommitsViewModel.h"

@interface MGRepoDetailViewController ()
<WKNavigationDelegate>

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) MGRepoDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WKWebView *readmeWeb;

@end

@implementation MGRepoDetailViewController
#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepoDetailViewModel *)viewModel;
        self.navigationItem.title = [self.viewModel.params valueForKey:kRepoDetailParamsKeyForRepoName];
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ceshi"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(test)];
    [self configUI];
    [self bindViewModel:nil];
    [self.tableView.mj_header beginRefreshing];

}
- (void)test{
    
    MGRepoCommitsViewModel *commits = [[MGRepoCommitsViewModel alloc]
                                       initWithParams:@{kRepoForKnowCommits:self.viewModel.repo,
                                                        kSHAForKnowCommits:self.viewModel.repo.defaultBranch}];
    [MGSharedDelegate.viewModelBased pushViewModel:commits animated:YES];
    
}
- (void)configUI{
    
    if ([self.navigationController.navigationBar isHidden]) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest subscribeNext:^(id x){
        @strongify(self);
        if (self.viewModel.readMEHtml) {
            [self.readmeWeb loadHTMLString:self.viewModel.readMEHtml baseURL:nil];
        }
        [self.headerView bindViewModel:self.viewModel.repo];
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.width, [self.headerView height]);
        [self.tableView reloadData];
    }];
}

#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    @weakify(self);
    [webView autoSetHeightAfterLoaded:^(CGFloat height) {
        webView.height = height;
        @strongify(self);
        [[RACScheduler mainThreadScheduler]schedule:^{
            self.tableView.tableFooterView.frame= CGRectMake(webView.x, webView.y, self.tableView.width, height);
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                              self.tableView.frame.origin.y,
                                              CGRectGetWidth(self.tableView.frame),
                                              CGRectGetHeight(self.tableView.frame)+height);
        }];
    }];
}

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:self.view.bounds binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            [binder setReuseXibCellClass:@[[MGOCTTreeEntryCell class]]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGOCTTreeEntryCell class]);
            }];
            [binder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return 40;
            }];
            binder.dataSourceSignal = self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.fetchDataFromServiceCommand.errors;
        }];
        _tableView.mj_header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.fetchDataFromServiceCommand execute:nil];
            }];
            header;
        });
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.readmeWeb;
    }
    return _tableView;
}
- (MGRepoDetailHeaderView *)headerView{
    
    if (_headerView==nil) {
        _headerView = [[MGRepoDetailHeaderView alloc]init];
    }
    return _headerView;
}
- (WKWebView *)readmeWeb{
    
    if (_readmeWeb==nil) {
        _readmeWeb = [[WKWebView alloc]init];
        _readmeWeb.navigationDelegate = self;
        _readmeWeb.backgroundColor = [UIColor redColor];
        _readmeWeb.scrollView.showsVerticalScrollIndicator = NO;
    }
    return _readmeWeb;
}

- (BOOL)willDealloc{
    
    return NO;
}
@end
