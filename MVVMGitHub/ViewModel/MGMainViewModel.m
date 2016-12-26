//
//  MGMainViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGMainViewModel.h"
#import "MGProfileViewModel.h"
#import "MGRepositoryViewModel.h"
#import "MGExploreViewModel.h"

NSString *const kTabBarItemTitle = @"kTabBarItemTitle";
NSString *const kTabBarSelectedImageName = @"kTabBarSelectedImageName";
NSString *const kTabBarNormalImageName = @"kTabBarNormalImageName";
NSString *const kClassMap = @"kClassMap";
NSString *const kNavigationTitle = @"kNavigationTitle";

@interface MGMainViewModel ()

@property (nonatomic, strong, readwrite) MGProfileViewModel *profileViewModel;
@property (nonatomic, strong, readwrite) MGRepositoryViewModel *repositorisViewModel;
@property (nonatomic, strong, readwrite) MGExploreViewModel *exploreViewModel;

@end

@implementation MGMainViewModel


- (void)initialize{
 
    NSDictionary *explpre = @{kTabBarItemTitle:@"Explpre",
                           kTabBarSelectedImageName:@"Icon-iPhone",
                           kTabBarNormalImageName:@"Icon-iPhone",
                           kClassMap:@"Explpre",
                           kNavigationTitle:@"Explpre"};
    
    NSDictionary *repositories = @{kTabBarItemTitle:@"Repositories",
                            kTabBarSelectedImageName:@"Icon-iPhone",
                            kTabBarNormalImageName:@"Icon-iPhone",
                            kClassMap:@"Repositories",
                            kNavigationTitle:@"Repositories"};
    
    NSDictionary *profile = @{kTabBarItemTitle:@"Profile",
                           kTabBarSelectedImageName:@"Icon-iPhone",
                           kTabBarNormalImageName:@"Icon-iPhone",
                           kClassMap:@"Profile",
                           kNavigationTitle:@"Profile"};
    
    self.exploreViewModel = [[MGExploreViewModel alloc]initWithParams:explpre];
    self.profileViewModel = [[MGProfileViewModel alloc]initWithParams:profile];
    self.repositorisViewModel = [[MGRepositoryViewModel alloc]initWithParams:repositories];
}


@end
