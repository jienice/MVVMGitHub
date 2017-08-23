//
//  MGMainViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGMainViewModel.h"
#import "MGExploreViewModel.h"
#import "MGProfileViewModel.h"
#import "MGRepositoryViewModel.h"
#import "MGSearchViewModel.h"

NSString *const kTabBarItemTitle = @"kTabBarItemTitle";
NSString *const kTabBarSelectedImageName = @"kTabBarSelectedImageName";
NSString *const kTabBarNormalImageName = @"kTabBarNormalImageName";

@interface MGMainViewModel ()


@end

@implementation MGMainViewModel


- (void)initialize{
    NSDictionary *explpre = @{kTabBarItemTitle:@"Explore",
                              kTabBarSelectedImageName:@"tab_explore_selected",
                              kTabBarNormalImageName:@"tab_explore_normal",
                              kClassMap:@"Explore"};
    
    NSDictionary *repositories = @{kTabBarItemTitle:@"Repo",
                                   kTabBarSelectedImageName:@"tab_repo_selected",
                                   kTabBarNormalImageName:@"tab_repo_normal",
                                   kClassMap:@"Repositories",
                                   kRepositorIsShowOnTabBar:@YES,
                                   kListRepositoriesUserName:[SAMKeychain mg_login]};
    
    NSDictionary *profile = @{kTabBarItemTitle:@"Profile",
                              kTabBarSelectedImageName:@"tab_profile_selected",
                              kTabBarNormalImageName:@"tab_profile_normal",
                              kClassMap:@"Profile",
                              kProfileIsShowOnTabBar:@YES,
                              kProfileOfUserLoginName:[SAMKeychain mg_login]};
    
    NSDictionary *search = @{kTabBarItemTitle:@"Search",
                             kTabBarSelectedImageName:@"Icon-iPhone",
                             kTabBarNormalImageName:@"Icon-iPhone",
                             kClassMap:@"Search"};
    
    _exploreViewModel = [[MGExploreViewModel alloc]initWithParams:explpre];
    _profileViewModel = [[MGProfileViewModel alloc]initWithParams:profile];
    _searchViewModel = [[MGSearchViewModel alloc]initWithParams:search];
    _repositorisViewModel = [[MGRepositoryViewModel alloc]initWithParams:repositories];
}


@end
