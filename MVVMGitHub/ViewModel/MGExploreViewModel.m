//
//  MGExploreViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewModel.h"
#import "MGApiService.h"

@interface MGExploreViewModel ()

@property (nonatomic, strong) RACCommand *requestTrendReposCommand;

@property (nonatomic, strong) RACCommand *requestPopularReposCommand;

@property (nonatomic, strong) RACCommand *requestShowcasesCommand;


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
        
        [self.requestTrendReposCommand execute:@0];
        [self.requestShowcasesCommand execute:@0];
        [self.requestPopularReposCommand execute:@0];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[[RACSignal combineLatest:@[self.requestShowcasesCommand.executionSignals.switchToLatest,
                                       self.requestPopularReposCommand.executionSignals.switchToLatest,
                                       self.requestTrendReposCommand.executionSignals.switchToLatest] reduce:^id(id showcases,
                                                                                                                 id popularRepos,
                                                                                                                 id trendRepos){
                                           return RACTuplePack(showcases,popularRepos,trendRepos);
                                       }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple *responseObject) {
                                           [subscriber sendNext:responseObject];
                                       } error:^(NSError *error) {
                                           [subscriber sendError:error];
                                       } completed:^{
                                           [subscriber sendCompleted];
                                       }];
            return nil;
        }];
    }];

    self.requestShowcasesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [MGApiService starNetWorkRequestWithHttpMethod:@"GET" baseUrl:EXPLORE_BASE_URL path:@"showcases" params:nil];
    }];
    
    self.requestPopularReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        
        return [MGApiService starNetWorkRequestWithHttpMethod:@"GET" baseUrl:EXPLORE_BASE_URL path:@"trending" params:nil];
    }];

    self.requestTrendReposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        
        return [MGApiService starNetWorkRequestWithHttpMethod:@"GET" baseUrl:EXPLORE_BASE_URL path:@"trending" params:nil];
    }];
}

@end
