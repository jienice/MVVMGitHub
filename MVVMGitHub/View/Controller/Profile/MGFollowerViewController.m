//
//  MGFollowerViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGFollowerViewController.h"
#import "MGFollowerViewModel.h"
#import "MGUserCell.h"
#import "MGProfileViewModel.h"

@interface MGFollowerViewController ()

@property (nonatomic, strong) MGFollowerViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation MGFollowerViewController


#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGFollowerViewModel *)viewModel;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
}
- (void)configUI{
    
    self.title = self.viewModel.title;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];
    self.view.backgroundColor = MGWhiteColor;
    [self.view addSubview:self.tableView];
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [[[self rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [self.tableView.binder.didSelectedCellCommand.executionSignals.switchToLatest subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        OCTUser *user = self.viewModel.dataSource[(NSUInteger) indexPath.row];
        MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                       initWithParams:@{kProfileOfUserLoginName:user.login,
                                                        kProfileIsShowOnTabBar:@NO}];
        [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
    }];
}
#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:self.view.bounds binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            binder.dataSourceSignal = [[RACObserve(self.viewModel, dataSource) ignore:nil] map:^id(NSArray *value) {
                return RACTuplePack(@YES,@YES,value);
            }];
            binder.errors = self.viewModel.fetchDataFromServiceCommand.errors;
            binder.reuseXibCellClass = @[[MGUserCell class]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGUserCell class]);
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
