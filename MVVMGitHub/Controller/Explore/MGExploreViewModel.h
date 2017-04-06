//
//  MGExploreViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGViewModel.h"
#import "MGExploreCellViewModel.h"

extern NSString *const kTrendReposDataSourceArrayKey;
extern NSString *const kShowcasesDataSourceArrayKey;
extern NSString *const kPopularUsersDataSourceArrayKey;
extern NSString *const kPopularReposDataSourceArrayKey;

@interface MGExploreViewModel : MGViewModel<MGTableViewModelProtocol>

@property (nonatomic, strong, readonly) RACCommand *requestTrendReposCommand;
@property (nonatomic, strong, readonly) RACCommand *requestPopularUsersCommand;
@property (nonatomic, strong, readonly) RACCommand *requestShowcasesCommand;
@property (nonatomic, strong, readonly) RACCommand *requestLanguageCommand;
@property (nonatomic, strong, readonly) RACCommand *requestPopularReposCommand;

@property (nonatomic, strong, readonly) NSMutableDictionary *dataSourceDict;


- (MGExploreCellViewModel *)configExploreRowViewModel:(MGExploreRowType)exploreRowType;

@end
