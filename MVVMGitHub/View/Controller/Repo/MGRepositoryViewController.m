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
@property (nonatomic, strong) MGTableViewBinder *tableViewBinder;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(mg_createRepository)];
    [self bindViewModel:nil];
}
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [[[self rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"fetchDataFromServiceCommand === %s",__func__);
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [self.tableViewBinder.didSelectedCellCommand.executionSignals.switchToLatest subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        MGRepositoriesModel *repo = self.viewModel.dataSource[indexPath.row];
        MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,kRepoDetailParamsKeyForRepoName:repo.name}];
        [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
    }];
    
    [self.viewModel.fetchDataFromServiceCommand.executing subscribeNext:^(NSNumber*execut) {
        if ([execut boolValue]) {
            [SVProgressHUD showWithStatus:@"loading..."];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
    
    
}
#pragma mark - Load Data

#pragma mark - Touch Action
- (void)mg_createRepository{
    
    MGCreateRepoViewModel *viewMode = [[MGCreateRepoViewModel alloc]initWithParams:@{kNavigationTitle:@"Create New Repositioy"}];
    [MGSharedDelegate.viewModelBased presentViewModel:viewMode animated:YES];
}

#pragma mark - Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%s repo -- %@",__func__,self.viewModel.dataSource[indexPath.row]);
    
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        @weakify(self);
        _tableView.mj_header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.fetchDataFromServiceCommand execute:0];
            }];
            [header.lastUpdatedTimeLabel setHidden:YES];
            header;
        });
        self.tableViewBinder = ({
            MGTableViewBinder *binder = [MGTableViewBinder binderWithTable:_tableView];
            [binder setDataSouceSignal:self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest];
            [binder setReuseNoXibCellClass:@[[MGRepositoriesCell class]]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGRepositoriesCell class]);
            }];
            [binder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return [MGRepositoriesCell cellHeight];
            }];
            binder;
        });
    }
    return _tableView;
}
@end
