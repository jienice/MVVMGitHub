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
#import <SDCycleScrollView/SDCycleScrollView.h>

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
    [[RACSignal combineLatest:@[self.viewModel.requestTrendReposCommand.executing,
                               self.viewModel.requestPopularUsersCommand.executing,
                               self.viewModel.requestShowcasesCommand.executing]
                       reduce:^id(NSNumber *trendExecute,
                                  NSNumber *popularExecute,
                                  NSNumber *showcasesExecute){
                           return @([trendExecute boolValue]||[popularExecute boolValue]||[showcasesExecute boolValue]);
    }] subscribeNext:^(NSNumber *trendExecute) {
        if(![trendExecute boolValue]){
            @strongify(self);
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
            }
        }
    }];
    
    [[[[RACObserve(self, viewModel.fetchDataFromServiceSuccess) distinctUntilChanged] filter:^BOOL(NSNumber *value) {
        return [value boolValue];
    }] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
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
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGExploreCell *cell = [MGExploreCell configExploreCell:tableView
                                           reuseIdentifier:@"MGExploreCell"
                                              rowViewModel:[self configExploreRowViewModel:indexPath]];

    cell.seeAllCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[RACSignal empty] takeUntil:cell.rac_prepareForReuseSignal];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MGExploreCell cellHeight];
}
- (MGExploreRowViewModel *)configExploreRowViewModel:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if (indexPath.row == MGExploreRowForTrendRepos) {
        [parames setObject:@"Trend Repos This Week" forKey:kExploreRowViewModelTitleKey];
        [parames setObject:[self.viewModel.dataSourceDict objectForKey:kTrendReposDataSourceArrayKey]
                    forKey:kExploreRowViewModelDataSourceKey];
        [parames setObject:@(MGExploreRowForTrendRepos) forKey:kExploreRowViewModelRowTypeKey];
        
    }else if(indexPath.row == MGExploreRowForPopularUsers) {
        [parames setObject:@"Popular Users" forKey:kExploreRowViewModelTitleKey];
        [parames setObject:[self.viewModel.dataSourceDict objectForKey:kPopularUsersDataSourceArrayKey]
                    forKey:kExploreRowViewModelDataSourceKey];
        [parames setObject:@(MGExploreRowForPopularUsers) forKey:kExploreRowViewModelRowTypeKey];
        
    }else if(indexPath.row == MGExploreRowForPopularRepos) {
        [parames setObject:@"Popular Repos" forKey:kExploreRowViewModelTitleKey];
        [parames setObject:[self.viewModel.dataSourceDict objectForKey:kPopularReposDataSourceArrayKey]
                    forKey:kExploreRowViewModelDataSourceKey];
        [parames setObject:@(MGExploreRowForPopularRepos) forKey:kExploreRowViewModelRowTypeKey];
    }
    MGExploreRowViewModel *rowViewModel = [[MGExploreRowViewModel alloc]initWithParams:parames];
    return rowViewModel;
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds
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
