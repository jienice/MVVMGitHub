//
//  MGSearchViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

typedef NS_ENUM(NSInteger,MGSearchType){
    MGSearchForUsers,
    MGSearchForRepositories
};

@interface MGSearchViewModel : MGViewModel


@property (nonatomic, assign) MGSearchType searchType;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSArray *selectionTitleArray;




@end
