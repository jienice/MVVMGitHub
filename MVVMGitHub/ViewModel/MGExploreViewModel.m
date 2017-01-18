//
//  MGExploreViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewModel.h"
#import "MGApiService.h"
#import "MGTrendRepoModel.h"
#import "MGShowcasesModel.h"

NSString *const kTrendDataSourceArrayKey = @"kTrendDataSourceArrayKey";
NSString *const kShowcasesDataSourceArrayKey = @"kShowcasesDataSourceArrayKey";

@interface MGExploreViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *requestTrendReposCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestPopularReposCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestShowcasesCommand;

@end

@implementation MGExploreViewModel

@synthesize page = _page;
@synthesize dataSource = _dataSource;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize cancelFetchDataSignal = _cancelFetchDataSignal;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

#define EXPLORE_BASE_URL @"http://trending.codehub-app.com/v2/"

- (void)initialize{
    
    self.cancelFetchDataSignal = self.rac_willDeallocSignal;    

    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [self.requestTrendReposCommand execute:nil];
        [self.requestShowcasesCommand execute:nil];
//        [self.requestPopularReposCommand execute:nil];
        return [RACSignal empty];
    }];

    self.requestShowcasesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[[[[MGApiService starNetWorkRequestWithHttpMethod:GET
                                                         baseUrl:EXPLORE_BASE_URL
                                                            path:@"showcases"
                                                          params:nil] retry:2]
                 takeUntil:self.cancelFetchDataSignal] doNext:^(NSArray *dataArr) {
            NSArray *showcases = [MGShowcasesModel mj_objectArrayWithKeyValuesArray:dataArr];
            [self.dataSource addObject:@{kShowcasesDataSourceArrayKey:showcases}];
        }] doCompleted:^{
            
        }];
    }];

    self.requestPopularReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        
        return [[[[[MGApiService starNetWorkRequestWithHttpMethod:GET
                                                        baseUrl:EXPLORE_BASE_URL
                                                           path:@"trending"
                                                         params:nil] retry:2]
                takeUntil:self.cancelFetchDataSignal] doNext:^(id x) {
            
        }] doCompleted:^{
            
        }];
    }];

    self.requestTrendReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        return [[[[[MGApiService starNetWorkRequestWithHttpMethod:GET
                                                         baseUrl:EXPLORE_BASE_URL
                                                            path:@"trending"
                                                          params:nil] retry:2]
                 takeUntil:self.cancelFetchDataSignal] doNext:^(NSArray *dataArr) {
            NSArray *trending = [MGTrendRepoModel mj_objectArrayWithKeyValuesArray:dataArr];
            [self.dataSource addObject:@{kTrendDataSourceArrayKey:trending}];
        }] doCompleted:^{
            
        }];
    }];
    
}

@end
