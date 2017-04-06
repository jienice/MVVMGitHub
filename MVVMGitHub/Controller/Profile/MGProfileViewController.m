//
//  MGUserViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGProfileViewController.h"
#import "MGProfileViewModel.h"

@interface MGProfileViewController ()

@property (nonatomic, weak) MGProfileViewModel *viewModel;

@end

@implementation MGProfileViewController


#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGProfileViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
}
- (void)bindViewModel{}

#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method

#pragma mark - Lazy Load


@end
