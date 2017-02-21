//
//  MGMainViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"
#import "MGProfileViewModel.h"
#import "MGRepositoryViewModel.h"
#import "MGExploreViewModel.h"


@interface MGMainViewModel : MGViewModel


@property (nonatomic, strong, readonly) MGProfileViewModel *profileViewModel;

@property (nonatomic, strong, readonly) MGRepositoryViewModel *repositorisViewModel;

@property (nonatomic, strong, readonly) MGExploreViewModel *exploreViewModel;



@end
