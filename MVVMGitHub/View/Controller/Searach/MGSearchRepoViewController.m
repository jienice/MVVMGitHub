//
//  MGSearchRepoViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchRepoViewController.h"
#import "MGSearchViewModel.h"
#import "MGRepoDetailViewModel.h"
#import "MGRepoCell.h"

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
    [self.viewModel.searchRepoCommand.executing subscribeNext:^(NSNumber *execut) {
        if ([execut boolValue]) {
            [SVProgressHUD show];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
    self.tableView.binder.didSelectedCellCommand = self.viewModel.didSelectedRowCommand;
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
            binder.reuseXibCellClass = @[[MGRepoCell class]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGRepoCell class]);
            }];
        }];
    }
    return _tableView;
}
@end
