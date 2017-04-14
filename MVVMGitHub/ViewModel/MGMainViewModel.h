//
//  MGMainViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

@class MGProfileViewModel;
@class MGRepositoryViewModel;
@class MGExploreViewModel;
@class MGSearchViewModel;

extern NSString *const kTabBarItemTitle;
extern NSString *const kTabBarSelectedImageName;
extern NSString *const kTabBarNormalImageName;

@interface MGMainViewModel : MGViewModel


@property (nonatomic, strong, readonly) MGProfileViewModel *profileViewModel;

@property (nonatomic, strong, readonly) MGRepositoryViewModel *repositorisViewModel;

@property (nonatomic, strong, readonly) MGExploreViewModel *exploreViewModel;

@property (nonatomic, strong, readonly) MGSearchViewModel *searchViewModel;


@end
