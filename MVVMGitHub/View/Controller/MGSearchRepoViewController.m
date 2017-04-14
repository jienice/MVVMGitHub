//
//  MGSearchRepoViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchRepoViewController.h"
#import "MGSearchViewModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MGRepositoriesCell.h"

@interface MGSearchRepoViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation MGSearchRepoViewController

#pragma mark - Instance Method

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view setBackgroundColor:[UIColor redColor]];
    [self.tableView registerClass:[MGRepositoriesCell class]
           forCellReuseIdentifier:NSStringFromClass([MGRepositoriesCell class])];
    self.tableView.mj_header = ({
        @weakify(self);
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.searchType = MGSearchForRepositories;
            [self.viewModel.searchCommand execute:nil];
        }];
        header;
    });
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.resultForRepo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MGRepositoriesCell configCellForTableView:tableView
                                           repository:self.viewModel.resultForRepo[indexPath.row]
                                      reuseIdentifier:NSStringFromClass([MGRepositoriesCell class])];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MGRepositoriesCell cellHeight];
}
#pragma mark - Lazy Load

@end
