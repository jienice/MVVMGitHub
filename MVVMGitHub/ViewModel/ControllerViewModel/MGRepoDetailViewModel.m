//
//  MGRepoDetailViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailViewModel.h"
#import "MGRepositoriesModel.h"
#import "MGApiImpl+MGRepo.h"

NSString *const kRepoDetailParamsKeyForRepoOwner = @"kRepoDetailParamsKeyForRepoOwner";
NSString *const kRepoDetailParamsKeyForRepoName = @"kRepoDetailParamsKeyForRepoName";

@interface MGRepoDetailViewModel()

@property (nonatomic, copy) NSString *repoOwner;
@property (nonatomic, copy) NSString *repoName;


@end

@implementation MGRepoDetailViewModel

@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;
@synthesize page                        = _page;
@synthesize dataSource                  = _dataSource;
@synthesize didSelectedRowCommand       = _didSelectedRowCommand;



- (void)initialize{
    
    NSParameterAssert([self.params objectForKey:kRepoDetailParamsKeyForRepoOwner]);
    NSParameterAssert([self.params objectForKey:kRepoDetailParamsKeyForRepoName]);
    _repoOwner = [self.params objectForKey:kRepoDetailParamsKeyForRepoOwner];
    _repoName = [self.params objectForKey:kRepoDetailParamsKeyForRepoName];
    
    RACCommand *fetchRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[MGApiImpl sharedApiImpl] fetchRepoDetailWithOwner:_repoOwner
                                                           repoName:_repoName] doNext:^(NSDictionary *repoDic) {
            _repo = [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                  fromJSONDictionary:repoDic error:nil];
        }];
    }];
    
    RACCommand *fetchRepoOthersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal zip:@[[MGSharedDelegate.client
                                 fetchTreeForReference:_repo.defaultBranch inRepository:_repo recursive:NO],
                                [MGSharedDelegate.client
                                 fetchRepositoryReadme:_repo],
                                [[MGSharedDelegate.client
                                  fetchBranchesForRepositoryWithName:_repo.name owner:_repo.ownerLogin] collect]]];
    }];
    
    
    _fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *fetchRepoSignal = [fetchRepoCommand execute:nil];
        return  [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [fetchRepoSignal subscribeNext:^(id x) {
                [[fetchRepoOthersCommand execute:nil] subscribeNext:^(RACTuple *tuple) {
                    _fileTree = [tuple first];
                    OCTFileContent *file = [tuple second];
                    _branches = [tuple last];
                    if ([file.encoding isEqualToString:@"base64"]) {
                        NSString *readME = [file.content base64DecodedString];
                        _readMEHtml = [[MMMarkdown HTMLStringWithMarkdown:readME
                                                                   extensions:MMMarkdownExtensionsGitHubFlavored
                                                                        error:nil] readMeHtmlString];
                    }
                    [subscriber sendNext:RACTuplePack(@YES,@YES,_fileTree.entries)];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendCompleted];
                }];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }] deliverOn:RACScheduler.mainThreadScheduler];
    }];
    
    _starRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [MGSharedDelegate.client starRepository:_repo];
    }];
  
    
    
}
@end
