//
//  MGRepositoryViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoryViewController.h"
#import "MGRepositoryViewModel.h"

@interface MGRepositoryViewController ()

@property (nonatomic, strong, readwrite) MGRepositoryViewModel *viewModel;

@end

@implementation MGRepositoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.viewModel.cancelFetchDataSignal = [self rac_signalForSelector:@selector(viewDidDisappear:)];
    [self.viewModel.fetchDataFromServiceCommand execute:@1];
    
    [[RACObserve(self.viewModel, dataSource) filter:^BOOL(NSArray *value) {
        return value;
    }] subscribeNext:^(NSArray *dataSource) {
        NSLog(@"dataSource == %@",dataSource);
    }];
    
    [self.viewModel.fetchDataFromServiceCommand.executing subscribeNext:^(NSNumber*execut) {
        if ([execut boolValue]) {
            [SVProgressHUD showWithStatus:@"loading..."];
        }else{
            [SVProgressHUD dismissHUD];
        }
    }];
}
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepositoryViewModel *)viewModel;
    }
    return self;
}
@end
