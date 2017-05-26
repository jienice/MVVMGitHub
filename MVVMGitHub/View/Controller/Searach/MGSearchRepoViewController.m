//
//  MGSearchRepoViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchRepoViewController.h"
#import "MGSearchViewModel.h"
#import "MGRepositoriesCell.h"
#import "MGTableViewBinder.h"

@interface MGSearchRepoViewController ()

@property (nonatomic, strong) MGTableViewBinder *tableViewBinder;

@end

@implementation MGSearchRepoViewController

#pragma mark - Instance Method

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    self.tableView.mj_header = ({
        @weakify(self);
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.searchType = MGSearchForRepositories;
            [self.viewModel.searchCommand execute:nil];
        }];
        header;
    });
    
    self.tableViewBinder = ({
        MGTableViewBinder *binder = [MGTableViewBinder binderWithTable:self.tableView];
//        [binder setDataSouceSignal:self.viewModel.fetchDataFromServiceCommand.executionSignals.switchToLatest];
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
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load

@end
