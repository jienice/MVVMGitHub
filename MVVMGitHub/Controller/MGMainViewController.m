//
//  MGMainViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGMainViewController.h"
#import "MGMainViewModel.h"

//#import "MGProfileViewModel.h"
//#import "MGExploreViewModel.h"
//#import "MGRepositoryViewModel.h"
//#import "MGExploreViewController.h"
//#import "MGRepositoryViewController.h"
//#import "MGProfileViewController.h"

@interface MGMainViewController ()

@property (nonatomic, strong, readwrite) MGMainViewModel *viewModel;

@end

@implementation MGMainViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGMainViewModel *)viewModel;
        [self addViewModel:self.viewModel.exploreViewModel];
        [self addViewModel:self.viewModel.repositorisViewModel];
        [self addViewModel:self.viewModel.profileViewModel];
    }
    return self;
}
#pragma clang diagnostic pop

- (void)bindViewModel{}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = YES;
    //关闭滑屏返回
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)addViewModel:(MGViewModel *)viewModel{
    
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:[viewModel.params valueForKey:kTabBarItemTitle]
                                                      image:[[UIImage imageNamed:[viewModel.params valueForKey:kTabBarNormalImageName]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:[viewModel.params valueForKey:kTabBarSelectedImageName]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBAlphaColor(0, 0, 0, 1)} forState:UIControlStateNormal];
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    MGViewController *vc = (MGViewController *)[MGSharedDelegate.viewModelMapper viewControllerForViewModel:viewModel];
    vc.tabBarItem = item;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
