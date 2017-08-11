//
//  MGSearchViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGViewModel.h"



extern NSString *const kSearchText;



typedef NS_ENUM(NSInteger,MGSearchType){
    MGSearchForUsers = 0,
    MGSearchForRepositories
};

@interface MGSearchViewModel : MGViewModel

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, assign) MGSearchType searchType;

@property (nonatomic, strong) NSString *searchLanguage;

@property (nonatomic, strong, readonly) RACCommand *searchUserCommand;

@property (nonatomic, strong, readonly) RACCommand *searchRepoCommand;

@property (nonatomic, strong, readonly) RACSignal *enabledSignal;

@property (nonatomic, assign, readonly) CGRect tableViewFrame;

@property (nonatomic, strong, readonly) NSMutableArray *searchUserResultData;

@property (nonatomic, strong, readonly) NSMutableArray *searchRepoResultData;




@end
