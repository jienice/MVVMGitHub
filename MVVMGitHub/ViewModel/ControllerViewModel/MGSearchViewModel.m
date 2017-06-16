//
//  MGSearchViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchViewModel.h"
#import "MGApiImpl+MGSearch.h"

@interface MGSearchViewModel ()


@end

@implementation MGSearchViewModel

- (void)initialize{
    
    _enabledSignal = [[RACObserve(self, searchText) distinctUntilChanged] map:^id(NSString *value) {
        NSLog(@"searchText --- %@",value);
        return value.length>=3?@YES:@NO;
    }];
    
    _searchCommand = [[RACCommand alloc]initWithEnabled:self.enabledSignal signalBlock:^RACSignal *(id input) {
        switch (self.searchType) {
            case MGSearchForUsers:
                return [[MGApiImpl sharedApiImpl] searchUserWithKeyWord:self.searchText
                                                               language:[SAMKeychain mg_preferenceLanguage]
                                                                   sort:nil
                                                                  order:nil];
                break;
            case MGSearchForRepositories:
                return [[MGApiImpl sharedApiImpl] searchRepositoriesWithKeyWord:self.searchText
                                                                       language:[SAMKeychain mg_preferenceLanguage]
                                                                           sort:nil
                                                                          order:nil];
                break;
            default:
                break;
        }
    }];
}
- (void)setSearchType:(MGSearchType)searchType{
    
    if (_searchType==searchType) return;
    _searchType = searchType;
}
@end