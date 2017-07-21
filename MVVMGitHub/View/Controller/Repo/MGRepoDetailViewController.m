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
#import "WKWebView+MGWeb.h"
#import "MGRepoCommitsViewModel.h"
#import "MGProfileViewModel.h"
#import "MGSourceCodeViewModel.h"

@interface MGRepoDetailViewController ()
<WKNavigationDelegate>

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) MGRepoDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WKWebView *readmeWeb;

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ceshi"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(test)];
    [self configUI];
    [self bindViewModel:nil];
    [self.tableView.mj_header beginRefreshing];
}
- (void)test{
    
    MGRepoCommitsViewModel *commits = [[MGRepoCommitsViewModel alloc]
                                       initWithParams:@{kRepoForKnowCommits:self.viewModel.repo,
                                                        kSHAForKnowCommits:self.viewModel.repo.defaultBranch}];
    [MGSharedDelegate.viewModelBased pushViewModel:commits animated:YES];
    
}
- (void)configUI{
    
    if ([self.navigationController.navigationBar isHidden]) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [[RACObserve(self, viewModel.repo) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView bindViewModel:self.viewModel.repo];
    }];
    
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
        [self.tableView reloadData];
    }];
    
    [self.headerView.nameLabelClickedCommand.executionSignals.switchToLatest subscribeNext:^(NSString *login) {
        MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                       initWithParams:@{kProfileOfUserLoginName:login}];
        [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
    }];
    
    
    [self.tableView.binder.didSelectedCellCommand.executionSignals.switchToLatest subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        OCTTreeEntry *tree = self.viewModel.dataSource[indexPath.row];
        switch (tree.type) {
            case OCTTreeEntryTypeBlob:{
                [[MGSharedDelegate.client fetchBlob:tree.SHA inRepository:self.viewModel.repo] subscribeNext:^(NSData *data) {
                    NSLog(@"OCTTreeEntryTypeBlob -- %@",[data utf8String]);
                }];
            }
                break;
            case OCTTreeEntryTypeTree:{
                [[MGSharedDelegate.client fetchTreeForReference:tree.SHA inRepository:self.viewModel.repo recursive:NO] subscribeNext:^(OCTTree *tree) {
                    NSLog(@"OCTTreeEntryTypeTree --- %@",tree);
                }];
            }
                break;
            case OCTTreeEntryTypeCommit:{
                [[MGSharedDelegate.client fetchCommit:tree.SHA inRepository:self.viewModel.repo] subscribeNext:^(id x) {
                    NSLog(@"OCTTreeEntryTypeCommit -- %@",x);
                }];
            }
                break;
            default:
                break;
        }
        
        MGSourceCodeViewModel *soureCode = [[MGSourceCodeViewModel alloc]initWithParams:nil];
        [MGSharedDelegate.viewModelBased pushViewModel:soureCode animated:YES];
        
    }];
}

#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:self.view.bounds binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            [binder setReuseXibCellClass:@[[MGOCTTreeEntryCell class]]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGOCTTreeEntryCell class]);
            }];
            binder.dataSourceSignal = self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.fetchDataFromServiceCommand.errors;
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
- (WKWebView *)readmeWeb{
    
    if (_readmeWeb==nil) {
        _readmeWeb = [[WKWebView alloc]init];
        _readmeWeb.navigationDelegate = self;
        _readmeWeb.backgroundColor = [UIColor redColor];
        _readmeWeb.scrollView.showsVerticalScrollIndicator = NO;
    }
    return _readmeWeb;
}

@end
