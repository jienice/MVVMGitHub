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
#import "MGExploreRowViewModel.h"
#import "MGRepositoriesModel.h"
#import "MGRepoDetailViewModel.h"
#import "MGRepoDetailViewController.h"
#import "MGUserDetailViewModel.h"
@interface MGExploreViewController ()
<UITableViewDelegate,
UITableViewDataSource,
SDCycleScrollViewDelegate>

@property (nonatomic, strong, readwrite) MGExploreViewModel *viewModel;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UITableView *tableView;


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
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}
- (void)bindViewModel{
    
    @weakify(self);
    [[[[RACObserve(self, viewModel.fetchDataFromServiceSuccess) filter:^BOOL(NSNumber *value) {
        return [value boolValue];
    }] deliverOn:[RACScheduler mainThreadScheduler]] doNext:^(id x) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        NSArray *cycleScrollViewDataSource = [[[[self.viewModel.dataSourceDict valueForKey:kShowcasesDataSourceArrayKey] rac_sequence]
                                               map:^id(MGShowcasesModel *showcase) {
            return showcase.image_url;
        }] array];
        [self.cycleScrollView setImageURLStringsGroup:cycleScrollViewDataSource];
    }];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.viewModel.dataSourceDict allKeys].count-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGExploreCell *cell = [MGExploreCell configExploreCell:tableView
                                           reuseIdentifier:@"MGExploreCell"
                                              rowViewModel:[self.viewModel configExploreRowViewModel:indexPath.row]];
    [[cell.seeAllCommand.executionSignals.switchToLatest takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *rowType) {
        NSLog(@"查看全部%@",rowType);
    }];
    
    [[cell.didSelectedItemCommand.executionSignals.switchToLatest takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(RACTuple *tucple) {
        MGExploreRowViewModel *rowViewModel = [tucple first];
        NSIndexPath *indexPath = [tucple last];
        NSLog(@"选中%@",indexPath);
        if (rowViewModel.rowType == MGExploreRowForPopularUsers) {
            OCTUser *user=rowViewModel.dataSource[indexPath.item];
            NSLog(@"%@",user);
            MGUserDetailViewModel *userDetailViewModel = [[MGUserDetailViewModel alloc]
                                                          initWithParams:@{kNavigationTitle:user.name,
                                                                           kUserDetailViewModelParamsKeyForUser:user}];
            [MGSharedDelegate.viewModelBased pushViewModel:userDetailViewModel animated:YES];
        }else{
            MGRepositoriesModel *repo=rowViewModel.dataSource[indexPath.item];
            MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.owner.login,kRepoDetailParamsKeyForRepoName:repo.name}];
            [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MGExploreCell cellHeight];
}

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.fetchDataFromServiceCommand
                                                                refreshingAction:@selector(execute:)];
        _tableView.tableHeaderView.frame = self.cycleScrollView.bounds;
        _tableView.tableHeaderView = self.cycleScrollView;
    }
    return _tableView;
}
- (SDCycleScrollView *)cycleScrollView{
    
    if (_cycleScrollView == nil) {
        CGRect cycleScrollViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:cycleScrollViewFrame
                                                              delegate:self
                                                      placeholderImage:nil];
        _cycleScrollView.backgroundColor = [UIColor greenColor];
    }
    return _cycleScrollView;
}
@end
