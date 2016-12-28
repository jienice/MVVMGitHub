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

@property (nonatomic, strong, readwrite) MGExploreViewModel *viewModel;

@end

@implementation MGExploreViewController


- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGExploreViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[[self rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(id x) {
        [self.viewModel.fetchDataFromServiceCommand execute:nil];
    }];
}
- (void)bindViewModel{
    
    [self.viewModel.fetchDataFromServiceCommand.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            [SVProgressHUD showWithStatus:@"loading..."];
        }else{
            [SVProgressHUD dismissHUD];
        }
    }];
}
@end
