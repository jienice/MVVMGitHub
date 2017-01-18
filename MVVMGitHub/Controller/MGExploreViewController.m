//
//  MGExploreViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewController.h"
#import "MGExploreViewModel.h"
@interface MGExploreViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readwrite) MGExploreViewModel *viewModel;
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
    
    [[RACSignal combineLatest:@[self.viewModel.requestTrendReposCommand.executing,
                               self.viewModel.requestPopularReposCommand.executing,
                               self.viewModel.requestShowcasesCommand.executing]
                       reduce:^id(NSNumber *trendExecute,
                                  NSNumber *popularExecute,
                                  NSNumber *showcasesExecute){
                           return @([trendExecute boolValue]||[popularExecute boolValue]||[showcasesExecute boolValue]);
    }] subscribeNext:^(NSNumber *trendExecute) {
        if([trendExecute boolValue]){
            [SVProgressHUD showWithStatus:@"loading..."];
        }else{
            [SVProgressHUD dismissHUD];
        }
    }];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.viewModel.dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dict = self.viewModel.dataSource[section];
    NSArray *arr = [dict allValues][0];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return nil;
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.fetchDataFromServiceCommand
                                                                refreshingAction:@selector(execute:)];
        
    }
    return _tableView;
}
@end
