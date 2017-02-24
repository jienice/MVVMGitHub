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
#import "WKWebView+MGWeb.h"
#import "MGRepoDetailHeaderView.h"
#import "MGOCTTreeEntryCell.h"

#define TREE_ENTRY_CELL_HEIGHT 40

@interface MGRepoDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,WKNavigationDelegate>

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) MGRepoDetailHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
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
    [self configUI];
    [self.viewModel.fetchDataFromServiceCommand execute:nil];
}
- (void)configUI{
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.readmeWeb];
}
- (void)bindViewModel{
    
    @weakify(self);
    [[[RACObserve(self, viewModel.fileTree) ignore:nil] distinctUntilChanged] subscribeNext:^(OCTTree *fileTree) {
        @strongify(self);
        [[RACScheduler mainThreadScheduler] schedule:^{
            [self.tableView reloadData];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(fileTree.entries.count*TREE_ENTRY_CELL_HEIGHT);
            }];
        }];
    }];
    
    [[[RACObserve(self, viewModel.readMEHtml) ignore:nil] distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        [self.readmeWeb loadHTMLString:self.viewModel.readMEHtml baseURL:nil];
    }];
    
    [[RACObserve(self, viewModel.repo) ignore:nil] subscribeNext:^(MGRepositoriesModel *repo) {
        @strongify(self);
        [self.headerView setRepo:repo];
    }];
    
    [self.viewModel.fetchDataFromServiceCommand.executing subscribeNext:^(NSNumber *execut) {
        if (![execut boolValue]) {
            if ([self.scrollView.mj_header isRefreshing]) {
                [self.scrollView.mj_header endRefreshing];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showWithStatus:@"loading"];
        }
    }];
}
- (void)updateViewConstraints{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(self.headerView.height);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(0.1f);
    }];
    [self.readmeWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.1f);
    }];
    [super updateViewConstraints];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    [webView autoSetHeightAfterLoaded:^(CGFloat height) {
        [[RACScheduler mainThreadScheduler]schedule:^{
            [webView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        }];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.fileTree.entries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MGOCTTreeEntryCell configOCTTreeCellWithTableView:tableView
                                                    treeEntry:self.viewModel.fileTree.entries[indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TREE_ENTRY_CELL_HEIGHT;
}
#pragma mark - Lazy Load
- (UIScrollView *)scrollView{
    
    if(_scrollView==nil){
        _scrollView = [[UIScrollView alloc]init];
        @weakify(self);
        _scrollView.mj_header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.fetchDataFromServiceCommand execute:nil];
            }];
            [header.lastUpdatedTimeLabel setHidden:YES];
            header;
        });
    }
    return _scrollView;
}
- (UIView *)contentView{
    
    if(_contentView==nil){
        _contentView = [[UIView alloc]init];
//        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (MGRepoDetailHeaderView *)headerView{
    
    if (_headerView==nil) {
        _headerView=[[MGRepoDetailHeaderView alloc]init];
    }
    return _headerView;
}
- (WKWebView *)readmeWeb{
    
    if (_readmeWeb==nil) {
        _readmeWeb = [[WKWebView alloc]init];
        _readmeWeb.navigationDelegate = self;
    }
    return _readmeWeb;
}
- (BOOL)willDealloc{
    
    return NO;
}
@end
