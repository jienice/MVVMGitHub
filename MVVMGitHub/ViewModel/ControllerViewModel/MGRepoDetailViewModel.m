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

@property (nonatomic, strong, readwrite) NSString *readMEHtml;
@property (nonatomic, strong, readwrite) RACCommand *watchRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *starRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *forkRepoCommand;
@property (nonatomic, strong, readwrite) MGRepositoriesModel *repo;
@property (nonatomic, strong, readwrite) NSArray *branches;
@property (nonatomic, strong, readwrite) OCTTree *fileTree;

@property (nonatomic, copy) NSString *repoOwner;
@property (nonatomic, copy) NSString *repoName;


@end

@implementation MGRepoDetailViewModel

@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (void)initialize{
    
    self.repoOwner = [self.params objectForKey:kRepoDetailParamsKeyForRepoOwner];
    self.repoName = [self.params objectForKey:kRepoDetailParamsKeyForRepoName];
    
    @weakify(self);
    RACCommand *fetchRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[MGApiImpl sharedApiImpl] fetchRepoDetailWithOwner:self.repoOwner
                                                           repoName:self.repoName] doNext:^(NSDictionary *repoDic) {
            self.repo = [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                                  fromJSONDictionary:repoDic error:nil];
        }];
    }];
    
    RACCommand *fetchRepoOthersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal zip:@[[MGSharedDelegate.client
                                 fetchTreeForReference:self.repo.defaultBranch inRepository:self.repo recursive:NO],
                                [MGSharedDelegate.client
                                 fetchRepositoryReadme:self.repo],
                                [[MGSharedDelegate.client
                                  fetchBranchesForRepositoryWithName:self.repo.name owner:self.repo.ownerLogin] collect]]];
    }];
    
    
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *fetchRepoSignal = [fetchRepoCommand execute:nil];
        return  [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [fetchRepoSignal subscribeNext:^(id x) {
                [[fetchRepoOthersCommand execute:nil] subscribeNext:^(RACTuple *tuple) {
                    @strongify(self);
                    [self setFileTree:[tuple first]];
                    OCTFileContent *file = [tuple second];
                    self.branches = [tuple last];
                    if ([file.encoding isEqualToString:@"base64"]) {
                        NSString *readME = [file.content base64DecodedString];
                        self.readMEHtml = [MMMarkdown HTMLStringWithMarkdown:readME extensions:MMMarkdownExtensionsGitHubFlavored error:nil];
                    }
                    [subscriber sendNext:RACTuplePack(@YES,@YES,self.fileTree.entries)];
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
    
    self.starRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [MGSharedDelegate.client starRepository:self.repo];
    }];
  
    
}
@end
