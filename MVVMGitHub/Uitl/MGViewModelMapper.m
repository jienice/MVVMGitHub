//
//  MGViewModelMapper.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModelMapper.h"

@implementation MGViewModelMapper{
    
    NSDictionary *_mapperDict;
}


- (instancetype)init{
    
    if (self = [super init]) {
        _mapperDict = @{@"MGRepoDetailViewModel":@"MGRepoDetailViewController",
                        @"MGExploreViewModel":@"MGExploreViewController",
                        @"MGLoginViewModel":@"MGLoginViewController",
                        @"MGProfileViewModel":@"MGProfileViewController",
                        @"MGRepositoryViewModel":@"MGRepositoryViewController",
                        @"MGExploreViewModel":@"MGExploreViewController",
                        @"MGUserDetailViewModel":@"MGUserDetailViewController",
                        @"MGSearchViewModel":@"MGSearchViewController",
                        @"MGMainViewModel":@"MGMainViewController",
                        @"MGRepoCommitsViewModel":@"MGRepoCommitsViewController",
                        @"MGFollowerViewModel":@"MGFollowerViewController",
                        @"MGFollowingViewModel":@"MGFollowingViewController"};
    }
    return self;
}

- (UIViewController<MGViewControllerProtocol> *)viewControllerForViewModel:(id<MGViewModelProtocol>)viewModel{
    
    NSString *viewControllerString = [_mapperDict valueForKey:NSStringFromClass(viewModel.class)];
    NSParameterAssert([NSClassFromString(viewControllerString) conformsToProtocol:@protocol(MGViewControllerProtocol)]);
    return [[NSClassFromString(viewControllerString) alloc] initWithViewModel:viewModel];
}


@end
