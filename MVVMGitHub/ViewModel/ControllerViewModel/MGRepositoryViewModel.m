//
//  MGRepositoryViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoryViewModel.h"
#import "MGApiImpl+MGRepo.h"
#import "MGRepoDetailViewModel.h"

NSString *const kListRepositoriesUserName = @"kListRepositoriesUserName";
NSString *const kRepositorIsShowOnTabBar = @"kRepositorIsShowOnTabBar";

@interface MGRepositoryViewModel ()

@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, assign) BOOL isShowOnTabBar;

@end

@implementation MGRepositoryViewModel

@synthesize page = _page;
@synthesize dataSource = _dataSource;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;


- (void)initialize{
    
    NSParameterAssert(self.params[kListRepositoriesUserName]);
    @weakify(self);
    self.ownerName = self.params[kListRepositoriesUserName];
    self.isShowOnTabBar = [self.params[kRepositorIsShowOnTabBar] boolValue];
    if (self.isShowOnTabBar) {
        self.title = @"Repository";
    }else{
        self.title = [NSString stringWithFormat:@"%@-Repository",self.ownerName];
    }
    
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchRepoListWithOwnerName:self.ownerName
                                                            repoType:MGRepoTypeDefault] doNext:^(NSArray *repoDicArr) {
            @strongify(self);
           self.dataSource = [[[[repoDicArr rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                 fromJSONDictionary:repoDic error:nil];
           }] array] mutableCopy];
        }];
    }];
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        MGRepositoriesModel *repo = self.dataSource[indexPath.row];
        MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]
                                             initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,
                                                              kRepoDetailParamsKeyForRepoName:repo.name}];
        [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
        return [RACSignal empty];
    }];
    
    
    
}
@end
