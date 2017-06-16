//
//  MGRepositoryViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoryViewController.h"
#import "MGRepositoryViewModel.h"
#import "MGRepositoriesCell.h"
#import "MGCreateRepoViewModel.h"
#import "MGRepoDetailViewModel.h"
#import "MGRepositoriesModel.h"
#import "MGTableViewBinder.h"

@interface MGRepositoryViewController ()

@property (nonatomic, weak, readwrite) MGRepositoryViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MGRepositoryViewController

#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepositoryViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self bindViewModel:nil];
    }
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [[[self rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [self.tableView.binder.didSelectedCellCommand.executionSignals.switchToLatest subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        MGRepositoriesModel *repo = self.viewModel.dataSource[indexPath.row];
        MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,kRepoDetailParamsKeyForRepoName:repo.name}];
        [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
    }];
    
}
#pragma mark - Load Data

#pragma mark - Touch Action
- (void)createRepository{
    
    MGCreateRepoViewModel *viewMode = [[MGCreateRepoViewModel alloc]initWithParams:@{}];
    [MGSharedDelegate.viewModelBased presentViewModel:viewMode animated:YES];
}

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:self.view.bounds binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGRepositoriesCell class]);
            }];
            [binder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return [MGRepositoriesCell cellHeight];
            }];
            binder.dataSourceSignal = self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.fetchDataFromServiceCommand.errors;
            binder.reuseNoXibCellClass = @[[MGRepositoriesCell class]];
        }];
        _tableView.mj_header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.fetchDataFromServiceCommand execute:0];
            }];
            header;
        });
    }
    return _tableView;
}
@end
