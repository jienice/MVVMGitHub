//
//  MGMainViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGMainViewController.h"
#import "MGMainViewModel.h"

@interface MGMainViewController ()<UITabBarControllerDelegate>

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
        self.navigationItem.title = self.viewModel.exploreViewModel.title;
    }
    return self;
}
#pragma clang diagnostic pop

- (void)bindViewModel{}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = self;
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
    MGViewController *vc = [MGSharedDelegate.viewModelBased.viewModelMapper viewControllerForViewModel:viewModel];
    vc.tabBarItem = item;
    [self addChildViewController:vc];
}
#pragma mark - Delegate Method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:NSClassFromString(@"MGExploreViewController")]) {
        self.navigationItem.title = self.viewModel.exploreViewModel.title;
    }else if ([viewController isKindOfClass:NSClassFromString(@"MGProfileViewController")]) {
        self.navigationItem.title = self.viewModel.profileViewModel.title;
    }else if ([viewController isKindOfClass:NSClassFromString(@"MGRepositoryViewController")]) {
        self.navigationItem.title = self.viewModel.repositorisViewModel.title;
    }
}
@end
