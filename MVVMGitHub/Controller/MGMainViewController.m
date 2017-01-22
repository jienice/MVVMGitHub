//
//  MGMainViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGMainViewController.h"
#import "MGMainViewModel.h"
#import "MGProfileViewModel.h"
#import "MGExploreViewModel.h"
#import "MGRepositoryViewModel.h"
#import "MGExploreViewController.h"
#import "MGRepositoryViewController.h"
#import "MGProfileViewController.h"

@interface MGMainViewController ()

@property (nonatomic, strong, readwrite) MGMainViewModel *viewModel;

@property (nonatomic, strong) MGRepositoryViewController *repositoryVC;
@property (nonatomic, strong) MGExploreViewController *exploreVC;
@property (nonatomic, strong) MGProfileViewController *profileVC;

@end

@implementation MGMainViewController

- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGMainViewModel *)viewModel;
        [self configSubVC];
    }
    return self;
}
- (void)bindViewModel{}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = YES;
    //关闭滑屏返回
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)configSubVC{
    
    [self addChildVc:self.exploreVC itemsParams:self.viewModel.exploreViewModel.params];
    [self addChildVc:self.repositoryVC itemsParams:self.viewModel.repositorisViewModel.params];
    [self addChildVc:self.profileVC itemsParams:self.viewModel.profileViewModel.params];
}

- (void)addChildVc:(UIViewController *)childVc itemsParams:(NSDictionary *)itemsParams{
    
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:[itemsParams valueForKey:kTabBarItemTitle]
                                                      image:[[UIImage imageNamed:[itemsParams valueForKey:kTabBarNormalImageName]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:[itemsParams valueForKey:kTabBarSelectedImageName]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBAlphaColor(0, 0, 0, 1)} forState:UIControlStateNormal];
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    childVc.tabBarItem = item;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}
#pragma mark - lazy load
- (MGRepositoryViewController *)repositoryVC{
    
    if (_repositoryVC == nil) {
        _repositoryVC = [[MGRepositoryViewController alloc]initWithViewModel:self.viewModel.repositorisViewModel];
        _repositoryVC.title = self.viewModel.repositorisViewModel.title;
    }
    return _repositoryVC;
}
- (MGProfileViewController *)profileVC{
    
    if (_profileVC == nil) {
        _profileVC  = [[MGProfileViewController alloc]initWithViewModel:self.viewModel.profileViewModel];
        _profileVC.title = self.viewModel.profileViewModel.title;
    }
    return _profileVC;
}
- (MGExploreViewController *)exploreVC{
    
    if (_exploreVC == nil) {
        _exploreVC  = [[MGExploreViewController alloc]initWithViewModel:self.viewModel.exploreViewModel];
        _exploreVC.title = self.viewModel.exploreViewModel.title;
    }
    return _exploreVC;
}

@end
