//
//  MGRepoCommitsViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/16.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoCommitsViewController.h"
#import "MGRepoCommitsViewModel.h"
#import "MGRepoCommitsCell.h"

@interface MGRepoCommitsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MGRepoCommitsViewModel *viewModel;

@end

@implementation MGRepoCommitsViewController

#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    if (self = [super init]) {
        self.viewModel = (MGRepoCommitsViewModel*)viewModel;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];
    [self configUI];
    [self bindViewModel:nil];
}
- (void)bindViewModel:(id)viewModel{
    @weakify(self);
    [[self rac_signalForSelector:@selector(viewDidAppear:)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UITableView *)tableView {
	if(_tableView == nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:CGRectMake(0, MGNAV_STATUS_BAR_HEIGHT,
                                                                  MGSCREEN_WIDTH, MGSCREEN_HEIGHT-MGNAV_STATUS_BAR_HEIGHT) binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            binder.dataSourceSignal = self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.fetchDataFromServiceCommand.errors;
            [binder setReuseXibCellClass:@[[MGRepoCommitsCell class]]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *IndexPath) {
                return NSStringFromClass([MGRepoCommitsCell class]);
            }];
        }];
        _tableView.mj_header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.fetchDataFromServiceCommand execute:nil];
            }];
            header;
        });
	}
	return _tableView;
}

@end
