//
//  MGSearchUserViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/11.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchUserViewController.h"
#import "MGUserCell.h"
#import "MGSearchViewModel.h"
#import "MGProfileViewModel.h"

@interface MGSearchUserViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak)  MGSearchViewModel*viewModel;
@end

@implementation MGSearchUserViewController

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
    [self.viewModel.searchUserCommand.executing subscribeNext:^(NSNumber *execut) {
        if ([execut boolValue]) {
//            [SVProgressHUD show];
        }else{
//            [SVProgressHUD dismiss];
        }
    }];
    
    [self.tableView.binder.didSelectedCellCommand.executionSignals.switchToLatest subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        OCTUser *user = self.viewModel.searchUserResultData[indexPath.row];
        MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                       initWithParams:@{kProfileOfUserLoginName:user.login}];
        [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
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
            binder.dataSourceSignal = self.viewModel.searchUserCommand.executionSignals.switchToLatest;
            binder.errors = self.viewModel.searchUserCommand.errors;
            binder.reuseXibCellClass = @[[MGUserCell class]];
            [binder setCellConfigBlock:^NSString *(NSIndexPath *indexPath) {
                return NSStringFromClass([MGUserCell class]);
            }];
            [binder setHeightConfigBlock:^CGFloat(NSIndexPath *indexPath) {
                return [MGUserCell cellHeight];
            }];
        }];
    }
    return _tableView;
}
@end
