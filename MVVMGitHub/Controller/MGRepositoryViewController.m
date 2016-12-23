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

- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}
@end
