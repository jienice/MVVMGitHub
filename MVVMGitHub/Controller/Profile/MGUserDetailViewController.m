//
//  MGUserDetailViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGUserDetailViewController.h"
#import "MGUserDetailHeaderView.h"
#import "MGUserDetailViewModel.h"

@interface MGUserDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) MGUserDetailHeaderView *headerView;
@property (nonatomic, strong) MGUserDetailViewModel *viewModel;
@property (nonatomic, strong) OCTUser *user;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MGUserDetailViewController

#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGUserDetailViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
        self.user = [self.viewModel.params objectForKey:kUserDetailViewModelParamsKeyForUser];
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"]
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:MGSharedDelegate.viewModelBased
                                                                           action:@selector(popViewModelAnimated:)];
}
- (void)configUI{
    
    [self.view addSubview:self.tableView];
    self.headerView.frame = CGRectMake(self.tableView.y, self.tableView.y,
                                       CGRectGetWidth(self.tableView.frame),
                                       self.headerView.height);
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.frame = self.headerView.frame;
}
- (void)bindViewModel{
    
    
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if(_tableView==nil){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (MGUserDetailHeaderView *)headerView{
    
    if (_headerView==nil) {
        _headerView = [MGUserDetailHeaderView configUserDetailHeaderWithUser:self.user];
    }
    return _headerView;
}
@end
