//
//  MGSearchViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"

typedef NS_ENUM(NSInteger,MGSearchType){
    MGSearchForUsers = 0,
    MGSearchForRepositories
};

@interface MGSearchViewModel : MGViewModel


@property (nonatomic, assign) MGSearchType searchType;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong, readonly) RACCommand *searchCommand;

@property (nonatomic, strong, readonly) RACSignal *enabledSignal;

@property (nonatomic, strong, readonly) NSArray *resultForUser;

@property (nonatomic, strong, readonly) NSArray *resultForRepo;


@end
