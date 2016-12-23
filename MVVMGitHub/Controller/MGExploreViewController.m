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
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

@end
