//
//  MGViewModelMapper.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModelMapper.h"
#import "MGViewController.h"
#import "MGViewModel.h"

@implementation MGViewModelMapper{
    
    NSDictionary *_mapperDict;
}


- (instancetype)init{
    
    if (self = [super init]) {
        _mapperDict = @{@"MGRepoDetailViewModel":@"MGRepoDetailViewController",
                        @"MGExploreViewModel":@"MGExploreViewController",
                        @"MGMainViewModel":@"MGMainViewController",
                        @"MGLoginViewModel":@"MGLoginViewController",
                        @"MGProfileViewModel":@"MGProfileViewController",
                        @"MGRepositoryViewModel":@"MGRepositoryViewController",
                        @"MGExploreViewModel":@"MGExploreViewController"};
    }
    return self;
}

- (MGViewController<MGViewModelProtocol>*)viewControllerForViewModel:(MGViewModel *)viewModel{
    
    NSString *viewControllerString = [_mapperDict valueForKey:NSStringFromClass(viewModel.class)];
    NSParameterAssert([NSClassFromString(viewControllerString) conformsToProtocol:@protocol(MGViewControllerProtocol)]);
    return [[NSClassFromString(viewControllerString) alloc] initWithViewModel:viewModel];
}


@end
