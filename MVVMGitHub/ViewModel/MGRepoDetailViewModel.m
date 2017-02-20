//
//  MGRepoDetailViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailViewModel.h"
#import "MGRepositoriesModel.h"
#import "MGRepositoriesModel+OCTRepos.h"


@interface MGRepoDetailViewModel()

@property (nonatomic, strong) RACCommand *fetchRepositoryReadmeCommand;

@property (nonatomic, strong, readwrite) NSString *readMEHtml;
@property (nonatomic, strong, readwrite) RACCommand *fetchRepoBranchsCommand;
@property (nonatomic, strong, readwrite) RACCommand *watchRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *starRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *forkRepoCommand;
@property (nonatomic, strong) OCTRepository *repo;

@end

@implementation MGRepoDetailViewModel

@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (instancetype)initWithRepo:(MGRepositoriesModel *)repo{
    
    NSDictionary *params = @{kNavigationTitle:repo.name};
    self = [super initWithParams:params];
    self.repo = [repo transToOCTRepository];
    return self;
}

- (void)initialize{
    
    NSLog(@"%s",__func__);
    @weakify(self);
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[RACSignal zip:@[[MGSharedDelegate.client fetchTreeForReference:self.repo.defaultBranch
                                                                   inRepository:self.repo recursive:NO],
                         [MGSharedDelegate.client fetchRepositoryReadme:self.repo]]]
                doNext:^(RACTuple *tuple) {
            OCTTree *tree = [tuple first];
            NSLog(@"%@",tree);

            OCTFileContent *file = [tuple last];
            if ([file.encoding isEqualToString:@"base64"]) {
                NSString *readME = [file.content base64DecodedString];
                self.readMEHtml = [MMMarkdown HTMLStringWithMarkdown:readME error:nil];
            }
        }];

    }];
    
    self.fetchRepositoryReadmeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[MGSharedDelegate.client fetchBranchesForRepositoryWithName:self.repo.name
                                                                       owner:self.repo.ownerLogin] collect]
                doNext:^(NSArray *branchs) {
                    NSLog(@"branchs == %@",branchs);
        }];
    }];
    
    
    self.starRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [MGSharedDelegate.client starRepository:self.repo];
    }];
  
    
    [[RACSignal merge:@[self.fetchRepositoryReadmeCommand.errors,
                        self.fetchDataFromServiceCommand.errors]]subscribeNext:^(NSError *error) {
        [self.error sendError:error];
    }];
}
@end
