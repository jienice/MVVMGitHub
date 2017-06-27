//
//  MGSearchRepoViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchRepoViewController.h"
#import "MGSearchViewModel.h"
#import "MGRepositoriesCell.h"
#import "MGRepoDetailViewModel.h"

@interface MGSearchRepoViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) MGSearchViewModel*viewModel;

@end

@implementation MGSearchRepoViewController

- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGSearchViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
}
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [self.viewModel.searchRepoCommand.executing subscribeNext:^(NSNumber *execut) {
        if ([execut boolValue]) {
            [SVProgressHUD show];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
    
    [self.tableView.binder.didSelectedCellCommand.executionSignals.switchToLatest subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        MGRepositoriesModel *repo = self.viewModel.searchRepoResultData[indexPath.row];
        MGRepoDetailViewModel *repoDetail =
        [[MGRepoDetailViewModel alloc]
         initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,
                          kRepoDetailParamsKeyForRepoName:repo.name}];
        [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
    }];
}
- (void)configUI{
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        @weakify(self);
        _tableView = [UITableView createTableWithFrame:self.viewModel.tableViewFrame binder:^(MGTableViewBinder *binder) {
            @strongify(self);
            binder.dataSourceSignal = self.viewModel.searchRepoCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.searchRepoCommand.errors;
            binder.reuseNoXibCellClass = @[[MGRepositoriesCell class]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGRepositoriesCell class]);
            }];
            [binder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return [MGRepositoriesCell cellHeight];
            }];
        }];
        _tableView.mj_header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel.searchRepoCommand execute:0];
            }];
            header;
        });
    }
    return _tableView;
}
@end
