//
//  MGExploreViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"


extern NSString *const kTrendDataSourceArrayKey;
extern NSString *const kShowcasesDataSourceArrayKey;


@interface MGExploreViewModel : MGViewModel<MGTableViewModelProtocol>

@property (nonatomic, strong, readonly) RACCommand *requestTrendReposCommand;
@property (nonatomic, strong, readonly) RACCommand *requestPopularReposCommand;
@property (nonatomic, strong, readonly) RACCommand *requestShowcasesCommand;

@end
