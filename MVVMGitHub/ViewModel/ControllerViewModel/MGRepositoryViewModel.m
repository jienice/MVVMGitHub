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
    
    NSParameterAssert([self.params objectForKey:kListRepositoriesUserName]);
    self.title = @"Repository";
    self.ownerName = [self.params objectForKey:kListRepositoriesUserName];
    
    _dataSource = [NSMutableArray array];
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[self fetchDataFromServiceWithPage:0] takeUntil:self.rac_willDeallocSignal];
    }];
    
    _didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(OCTRepository *repository) {
        return [RACSignal empty];
    }];    
}

- (RACSignal *)fetchDataFromServiceWithPage:(NSInteger)page{
    
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[[MGApiImpl sharedApiImpl] fetchRepoListWithOwnerName:self.ownerName
                                                      repoType:MGRepoTypeDefault]
         subscribeNext:^(NSArray *repoDicArr) {
            NSLog(@"Next ----");
            NSArray *repos = [[[repoDicArr rac_sequence] map:^id(NSDictionary *repoDic) {
                return [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                 fromJSONDictionary:repoDic error:nil];
            }] array];
            [_dataSource addObjectsFromArray:repos];
            [subscriber sendNext:RACTuplePack(@YES,@YES,_dataSource)];
        } error:^(NSError *error) {
            NSLog(@"Error ----");
            [subscriber sendError:error];
        } completed:^{
            NSLog(@"Completed ----");
            [subscriber sendCompleted];
        }];
        return nil;
    }] deliverOn:RACScheduler.mainThreadScheduler];
}

@end
