//
//  MGRepoDetailViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailViewController.h"
#import "MGRepoDetailViewModel.h"
#import "MGRepositoriesModel.h"
#import "WKWebView+MGWeb.h"

@interface MGRepoDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) MGRepoDetailViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MGRepoDetailViewController
#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepoDetailViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self.viewModel.fetchDataFromServiceCommand execute:nil];
}
- (void)configUI{
    
    [self.view addSubview:self.tableView];
}
- (void)bindViewModel{
    
    
    
}


#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.fileTree.entries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
