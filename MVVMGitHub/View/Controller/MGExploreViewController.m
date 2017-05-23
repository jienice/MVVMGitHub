//
//  MGExploreViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewController.h"
#import "MGExploreViewModel.h"
#import "MGExploreCell.h"
#import "MGShowcasesModel.h"
#import "MGExploreCellViewModel.h"
#import "MGRepositoriesModel.h"
#import "MGRepoDetailViewModel.h"
#import "MGUserDetailViewModel.h"
#import "MGSearchViewModel.h"
#import "MGTableViewBinder.h"

@interface MGExploreViewController ()
<SDCycleScrollViewDelegate>

@property (nonatomic, weak, readwrite) MGExploreViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MGTableViewBinder *tableViewBinder;
@end

@implementation MGExploreViewController

#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGExploreViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
    [self.tableView.mj_header beginRefreshing];
}
- (void)configUI{
    
    [self.view addSubview:self.tableView];
}
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [self.viewModel.requestShowcasesCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        @strongify(self);
        NSArray *cycleScrollViewDataSource = [[[x rac_sequence] map:^id(MGShowcasesModel *showcase) {
            return showcase.image_url;
        }] array];
        SDCycleScrollView *cycleScrollView = (SDCycleScrollView *)self.tableView.tableHeaderView;
        [cycleScrollView setImageURLStringsGroup:cycleScrollViewDataSource];
    }];
    
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MGSCREEN_WIDTH, MGSCREEN_HEIGHT)
                                                 style:UITableViewStylePlain];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.fetchDataFromServiceCommand
                                                                refreshingAction:@selector(execute:)];
        SDCycleScrollView *cycleScrollView = [self cycleScrollView];
        _tableView.tableHeaderView.frame = cycleScrollView.bounds;
        _tableView.tableHeaderView = cycleScrollView;
        self.tableViewBinder = ({
            MGTableViewBinder *tableViewBinder = [MGTableViewBinder binderWithTable:_tableView];
            [tableViewBinder setDataSouceSignal:self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest];
            [tableViewBinder setReuseXibCellClass:@[[MGExploreCell class]]];
            [tableViewBinder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGExploreCell class]);
            }];
            [tableViewBinder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return [MGExploreCell cellHeight];
            }];
            tableViewBinder;
        });
    }
    return _tableView;
}

- (SDCycleScrollView *)cycleScrollView{
    
    CGRect cycleScrollViewFrame = CGRectMake(0, 0, MGSCREEN_WIDTH, 150);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:cycleScrollViewFrame
                                                                            delegate:self
                                                                    placeholderImage:nil];
    cycleScrollView.backgroundColor = [UIColor greenColor];
    return cycleScrollView;
}
@end
