//
//  MGExploreViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewController.h"
#import "MGExploreViewModel.h"
#import "MGExploreTableViewCell.h"
#import "MGShowcasesModel.h"
#import "MGSearchViewModel.h"

@interface MGExploreViewController ()
<SDCycleScrollViewDelegate,UISearchBarDelegate>

@property (nonatomic, weak, readwrite) MGExploreViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;

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
    [self configUI];
    [self bindViewModel:nil];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    @weakify(self);
    [[RACObserve(self, viewModel.showCasesArray) ignore:nil] subscribeNext:^(NSArray *x) {
        @strongify(self);
        NSArray *cycleScrollViewDataSource = [[[[x rac_sequence] map:^id(MGShowcasesModel *showcase) {
            return showcase.image_url;
        }] take:10] array];
        SDCycleScrollView *cycleScrollView = (SDCycleScrollView *)self.tableView.tableHeaderView;
        [cycleScrollView setImageURLStringsGroup:cycleScrollViewDataSource];
    }];
    
    [[[self rac_signalForSelector:@selector(searchBarShouldBeginEditing:)
                     fromProtocol:@protocol(UISearchBarDelegate)] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.beginSearchCommand execute:nil];
    }];
    
    
    [self.viewModel.fetchDataFromServiceCommand.errors subscribeNext:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[kErrorMessageKey]];
    }];
}

#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - About UI
- (void)configUI{
    @weakify(self);
    self.navigationItem.titleView = ({
        @strongify(self);
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:self.navigationController.navigationBar.bounds];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.placeholder = kSearchBarPlaceholderString;
        searchBar.delegate = self;
        searchBar;
    });
    [self.view addSubview:self.tableView];
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    if (_tableView == nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:CGRectMake(0, MGNAV_STATUS_BAR_HEIGHT,
                                                                  MGSCREEN_WIDTH,
                                                                  MGSCREEN_HEIGHT-MGNAV_STATUS_BAR_HEIGHT-MGTAB_BAR_HEIGHT)
                                                binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            binder.dataSourceSignal = self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.fetchDataFromServiceCommand.errors;
            [binder setReuseXibCellClass:@[[MGExploreTableViewCell class]]];
            binder.cellConfigBlock = ^NSString *(NSIndexPath *indexPath){
                return NSStringFromClass([MGExploreTableViewCell class]);
            };
        }];        
        _tableView.mj_header =
        [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.fetchDataFromServiceCommand
                                         refreshingAction:@selector(execute:)];
        SDCycleScrollView *cycleScrollView = [self cycleScrollView];
        _tableView.tableHeaderView.frame = cycleScrollView.bounds;
        _tableView.tableHeaderView = cycleScrollView;
    }
    return _tableView;
}

- (SDCycleScrollView *)cycleScrollView{
    CGRect cycleScrollViewFrame = CGRectMake(0, 0, MGSCREEN_WIDTH, 150);
    SDCycleScrollView *cycleScrollView =
    [SDCycleScrollView cycleScrollViewWithFrame:cycleScrollViewFrame
                                       delegate:self
                               placeholderImage:nil];
    return cycleScrollView;
}
@end
