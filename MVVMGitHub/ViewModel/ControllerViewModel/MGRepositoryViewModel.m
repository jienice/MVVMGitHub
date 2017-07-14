//
//  MGRepositoryViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoryViewModel.h"
#import "MGApiImpl+MGRepo.h"

NSString *const kListRepositoriesUserName = @"kListRepositoriesUserName";

@interface MGRepositoryViewModel ()

@property (nonatomic, copy) NSString *ownerName;


@end

@implementation MGRepositoryViewModel

@synthesize page = _page;
@synthesize dataSource = _dataSource;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;


- (void)initialize{
    
    NSParameterAssert(self.params[kListRepositoriesUserName]);
    @weakify(self);
    self.title = @"Repository";
    self.ownerName = self.params[kListRepositoriesUserName];
    
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[MGApiImpl sharedApiImpl] fetchRepoListWithOwnerName:self.ownerName
                                                            repoType:MGRepoTypeDefault] doNext:^(NSArray *repoDicArr) {
           self.dataSource = [[[[repoDicArr rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                 fromJSONDictionary:repoDic error:nil];
           }] array] mutableCopy];
        }];
    }];
    _didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(OCTRepository *repository) {
        return [RACSignal empty];
    }];    
}
@end
