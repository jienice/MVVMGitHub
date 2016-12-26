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
    [[self.viewModel.fetchDataFromServiceCommand execute:nil] subscribeNext:^(id x) {
        NSLog(@"Next == %s",__func__);
    } error:^(NSError *error) {
        NSLog(@"error == %s",__func__);
        if (error.domain == OCTClientErrorDomain && error.code == 666) {
            
        }
    } completed:^{
        NSLog(@"completed == %s",__func__);
    }];
    
    
}
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGRepositoryViewModel *)viewModel;
    }
    return self;
}
@end
