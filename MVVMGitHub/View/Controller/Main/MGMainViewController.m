//
//  MGMainViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGMainViewController.h"
#import "MGMainViewModel.h"
#import "MGNavigationController.h"
@interface MGMainViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong, readwrite) MGMainViewModel *viewModel;

@end

@implementation MGMainViewController

#pragma mark - Instance Method

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGMainViewModel *)viewModel;
        [self addViewModel:self.viewModel.exploreViewModel];
        [self addViewModel:self.viewModel.searchViewModel];
        [self addViewModel:self.viewModel.repositorisViewModel];
        [self addViewModel:self.viewModel.profileViewModel];
    }
    return self;
}
#pragma clang diagnostic pop

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = self;
    //关闭滑屏返回
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [MGSharedDelegate.viewModelBased resetRootNavigationController:[[self childViewControllers]
                                                                    firstObject]];
}
- (void)bindViewModel:(id)viewModel{}

- (void)addViewModel:(MGViewModel *)viewModel{
    
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:[viewModel.params valueForKey:kTabBarItemTitle]
                                                      image:[[UIImage imageNamed:[viewModel.params valueForKey:kTabBarNormalImageName]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:[viewModel.params valueForKey:kTabBarSelectedImageName]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:MGSystemColor} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:MGRGBAlphaColor(0, 0, 0, 1)} forState:UIControlStateNormal];
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    UIViewController *vc = [MGSharedDelegate.viewModelBased.viewModelMapper viewControllerForViewModel:viewModel];
    vc.tabBarItem = item;
    MGNavigationController *nav = [[MGNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}
#pragma mark - Delegate Method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    MGNavigationController *nav = (MGNavigationController*)viewController;
    [MGSharedDelegate.viewModelBased resetRootNavigationController:nav];
}
@end
