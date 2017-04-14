//
//  MGSearchUserViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchUserViewController.h"
#import "MGSearchViewModel.h"
#import "UIScrollView+EmptyDataSet.h"


@interface MGSearchUserViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>



@end

@implementation MGSearchUserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.mj_header = ({
        @weakify(self);
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.searchType = MGSearchForUsers;
            [self.viewModel.searchCommand execute:nil];
        }];
        header;
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.resultForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
@end
