//
//  MGExploreViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreViewModel.h"

@interface MGExploreViewModel ()



@property (nonatomic, strong) RACCommand *requestTrendingReposCommand;
@property (nonatomic, strong) RACCommand *requestPopularReposCommand;

@property (nonatomic, strong) RACCommand *requestPopularUsersCommand;

@end

@implementation MGExploreViewModel
- (void)initialize{
    
//    @weakify(self);
//    self.requestPopularReposCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        return [[MGSharedDelegate.client fetchPopularRepositoriesWithLanguage:nil] doNext:^(NSArray *popularRepos) {
//                [[YYCache sharedCache] setObject:popularRepos forKey:nil withBlock:NULL];
//        }];
//    }];
//    
//    self.requestPopularUsersCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
//        @strongify(self)
//        return [[[[self.services client]
//                  fetchPopularUsersWithLocation:nil language:nil]
//                 retry:3]
//                doNext:^(NSArray *popularUsers) {
//                    [[YYCache sharedCache] setObject:popularUsers forKey:MRCExplorePopularUsersCacheKey withBlock:NULL];
//                }];
//    }];
}

- (RACSignal *)requestServiceDataWithPage:(NSInteger)page{
    
//    @weakify(self);
//    self.requestTrendingReposCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
//        @strongify(self)
//        return [[MGSharedDelegate.client requestTrendingRepositoriesSince:@"weekly" language:nil]
//                retry:3];
//    }];
    
    
    
    return [RACSignal empty];

}

@end
