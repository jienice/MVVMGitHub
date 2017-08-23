//
//  MGRepoDetailViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailViewController.h"
#import "MGRepoDetailViewModel.h"
#import "MGRepoDetailHeaderView.h"
#import "MGOCTTreeEntryCell.h"
#import "MGRepoCommitsViewModel.h"
#import "MGProfileViewModel.h"
#import "MGSourceCodeViewModel.h"

@interface MGRepoDetailViewController ()

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) MGRepoDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MGRepoDetailViewController
#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    if (self = [super init]) {
        self.viewModel = (MGRepoDetailViewModel *)viewModel;
        self.headerView = [[MGRepoDetailHeaderView alloc]init];
        self.navigationItem.title = [self.viewModel.params valueForKey:kRepoDetailParamsKeyForRepoName];
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
    self.headerView.nameLabelClickedCommand = self.viewModel.nameClickedCommand;
    self.tableView.binder.didSelectedCellCommand = self.viewModel.didSelectedRowCommand;
    self.headerView.branchClickedCommand = self.viewModel.branchClickedCommand;
    
    __block CGFloat headerViewHeight_;
    [[[self.headerView.didEndLayoutCommand.executionSignals.switchToLatest filter:^BOOL(NSNumber *headerViewHeight) {
        if (headerViewHeight_&&(headerViewHeight_==headerViewHeight.floatValue)) {
            return NO;
        }else{
            headerViewHeight_=headerViewHeight.floatValue;
            return YES;
        }
    }] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSNumber *headerViewHeight) {
        NSLog(@"headerViewHeight ---- %f",headerViewHeight.floatValue);
        @strongify(self);
        self.headerView.height = ceil([headerViewHeight floatValue]);
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.width, ceil([headerViewHeight floatValue]));
        [self.tableView setTableHeaderView:self.headerView];
    }];
    
    
    [[RACObserve(self, viewModel.repo) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView bindViewModel:self.viewModel.repo];
    }];
    
    [[RACObserve(self, viewModel.currentBranchName) ignore:NULL] subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView.changeBranchCommand execute:self.viewModel.currentBranchName];
    }];
    
    
    [self.viewModel.branchClickedCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *branchs) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Select Branch To List Files"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        @weakify(alert);
        [branchs enumerateObjectsUsingBlock:^(OCTBranch *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj.name
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               @strongify(self);
                                                               if (![action.title isEqualToString:self.viewModel.currentBranchName]) {
                                                                   self.viewModel.currentBranchName = action.title;
                                                               }
                                                           }];
            @strongify(alert);
            [alert addAction:action];
        }];
        @strongify(self);
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    
    [[[[RACSignal combineLatest:@[self.viewModel.fetchBranchsCommand.executing,
                                  self.viewModel.fetchTreeCommand.executing,
                                  self.viewModel.fetchDataFromServiceCommand.executing]
                         reduce:^NSNumber*(NSNumber *executBranch,NSNumber *executTree, NSNumber *executData){
                             if (executData.boolValue) {
                                 return @NO;
                             }
                             return @(executBranch.boolValue|executTree.boolValue);
    }] deliverOn:RACScheduler.mainThreadScheduler] skip:3]//忽略初始化
     subscribeNext:^(NSNumber *execut) {
        if (execut.boolValue) {
            [SVProgressHUD show];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - About UI
- (void)configUI{
    if ([self.navigationController.navigationBar isHidden]) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self updateConstraints];
}
- (void)updateConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    if (_tableView==nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithBinder:^(MGTableViewBinder *binder) {
            @strongify(self);
            [binder setReuseXibCellClass:@[[MGOCTTreeEntryCell class]]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGOCTTreeEntryCell class]);
            }];
            binder.dataSourceSignal = self.viewModel.fetchTreeCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.fetchTreeCommand.errors;
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
