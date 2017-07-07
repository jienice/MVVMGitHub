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
                              kTabBarSelectedImageName:@"Icon-iPhone",
                              kTabBarNormalImageName:@"Icon-iPhone",
                              kClassMap:@"Explore"};
    
    NSDictionary *repositories = @{kTabBarItemTitle:@"Repositories",
                                   kTabBarSelectedImageName:@"Icon-iPhone",
                                   kTabBarNormalImageName:@"Icon-iPhone",
                                   kClassMap:@"Repositories",
                                   kListRepositoriesUserName:[SAMKeychain mg_login]};
    
    NSDictionary *profile = @{kTabBarItemTitle:@"Profile",
                              kTabBarSelectedImageName:@"Icon-iPhone",
                              kTabBarNormalImageName:@"Icon-iPhone",
                              kClassMap:@"Profile",
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
