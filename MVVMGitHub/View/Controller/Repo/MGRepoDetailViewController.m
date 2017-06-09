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
#import "MGTableViewBinder.h"

@interface MGRepoDetailViewController ()
<WKNavigationDelegate>

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) MGRepoDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WKWebView *readmeWeb;
@property (nonatomic, strong) MGTableViewBinder *tableViewBinder;
@property (nonatomic, strong) RACSubject *fileTreeDataSignal;
@end

@implementation MGRepoDetailViewController
#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepoDetailViewModel *)viewModel;
        self.navigationItem.title = [self.viewModel.params valueForKey:kRepoDetailParamsKeyForRepoName];
        self.fileTreeDataSignal = [RACSubject subject];
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];

    [self configUI];
    [self bindViewModel:nil];
    [self.tableView.mj_header beginRefreshing];
}

- (void)configUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest subscribeError:^(NSError *error) {
        @strongify(self);
        [self.fileTreeDataSignal sendError:error];
    } completed:^{
        @strongify(self);
        [self.fileTreeDataSignal sendNext:RACTuplePack(@YES,self.viewModel.fileTree.entries)];
        [self.readmeWeb loadHTMLString:self.viewModel.readMEHtml baseURL:nil];
        [[RACScheduler mainThreadScheduler] schedule:^{
            [self.headerView bindViewModel:self.viewModel.repo];
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.width, [self.headerView height]);
            [self.tableView reloadData];
        }];
    }];

}
- (void)updateViewConstraints{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [super updateViewConstraints];
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
            self.tableView.tableFooterView.frame= CGRectMake(webView.x, webView.y, webView.width, height);
            self.tableView.height += height;
        }];
    }];
}

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = MGWhiteColor;
        _tableView.mj_header = ({
            @weakify(self);
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.fetchDataFromServiceCommand execute:nil];
            }];
            header;
        });
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.readmeWeb;
        self.tableViewBinder = ({
            MGTableViewBinder *binder = [MGTableViewBinder binderWithTable:self.tableView];
            [binder setReuseXibCellClass:@[[MGOCTTreeEntryCell class]]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGOCTTreeEntryCell class]);
            }];
            [binder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return 40;
            }];
            [binder setDataSouceSignal:self.fileTreeDataSignal];
            binder;
        });
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
    }
    return _readmeWeb;
}

- (BOOL)willDealloc{
    
    return NO;
}
@end
