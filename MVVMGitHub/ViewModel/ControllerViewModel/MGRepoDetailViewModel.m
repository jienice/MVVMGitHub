//
//  MGRepoDetailViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <CocoaSecurity/Base64.h>
#import "MGRepoDetailViewModel.h"
#import "MGApiImpl+MGRepo.h"
#import "MGProfileViewModel.h"
#import "MGSourceCodeViewModel.h"

NSString *const kRepoDetailParamsKeyForRepoOwner = @"kRepoDetailParamsKeyForRepoOwner";
NSString *const kRepoDetailParamsKeyForRepoName = @"kRepoDetailParamsKeyForRepoName";

@interface MGRepoDetailViewModel()

@property (nonatomic, copy) NSString *repoOwner;
@property (nonatomic, copy) NSString *repoName;
@property (nonatomic, strong, readwrite) NSArray *branches;
@property (nonatomic, strong, readwrite) MGRepositoriesModel *repo;
@property (nonatomic, strong, readwrite) OCTTree *fileTree;
@property (nonatomic, strong, readwrite) RACCommand *fetchBranchsCommand;
@property (nonatomic, strong, readwrite) RACCommand *fetchRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *fetchTreeCommand;
@property (nonatomic, strong, readwrite) RACCommand *watchRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *starRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *forkRepoCommand;
@property (nonatomic, strong, readwrite) RACCommand *nameClickedCommand;
@property (nonatomic, strong, readwrite) RACCommand *branchClickedCommand;

@end

@implementation MGRepoDetailViewModel

@synthesize page                        = _page;
@synthesize dataSource                  = _dataSource;
@synthesize didSelectedRowCommand       = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (void)initialize{
    NSParameterAssert(self.params[kRepoDetailParamsKeyForRepoOwner]);
    NSParameterAssert(self.params[kRepoDetailParamsKeyForRepoName]);
    self.repoOwner = self.params[kRepoDetailParamsKeyForRepoOwner];
    self.repoName = self.params[kRepoDetailParamsKeyForRepoName];
    
    @weakify(self);
    self.fetchDataFromServiceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return  [[self fetchDataSignal] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [[[[RACObserve(self, currentBranchName) ignore:NULL] distinctUntilChanged] skip:1] subscribeNext:^(id x) {
        NSLog(@"currentBranchName ==== %@",x);
        @strongify(self);
        [self.fetchTreeCommand execute:nil];
    }];
    
    
    self.nameClickedCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                       initWithParams:@{kProfileOfUserLoginName:self.repo.ownerLogin,
                                                        kProfileIsShowOnTabBar:@NO}];
        [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
        return [RACSignal empty];
    }];
    
    self.didSelectedRowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        OCTTreeEntry *tree = self.dataSource[indexPath.row];
        switch (tree.type) {
            case OCTTreeEntryTypeBlob:{
                @strongify(self);
                MGSourceCodeViewModel *soureCode = [[MGSourceCodeViewModel alloc]initWithParams:@{kSourceCodeOfRepo:self.repo,
                                                                                                  kSourceCodeSHA:tree.SHA,
                                                                                                  kSourceCodeFileName:tree.path}];
                [MGSharedDelegate.viewModelBased pushViewModel:soureCode animated:YES];
            }
                break;
            case OCTTreeEntryTypeTree:{
                @strongify(self);
                [[MGSharedDelegate.client fetchTreeForReference:tree.SHA inRepository:self.repo recursive:NO] subscribeNext:^(OCTTree *tree) {
                    NSLog(@"OCTTreeEntryTypeTree --- %@",tree);
                }];
            }
                break;
            case OCTTreeEntryTypeCommit:{
                @strongify(self);
                [[MGSharedDelegate.client fetchCommit:tree.SHA inRepository:self.repo] subscribeNext:^(id x) {
                    NSLog(@"OCTTreeEntryTypeCommit -- %@",x);
                }];
            }
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
    
    
    self.branchClickedCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%s",__func__);
        @strongify(self);
        if (self.branches) {
            return [RACSignal return:self.branches];
        }
        return [[[self.fetchBranchsCommand execute:nil] catch:^RACSignal *(NSError *error) {
            return [RACSignal error:error];
        }] then:^RACSignal *{
            @strongify(self);
            return [RACSignal return:self.branches];
        }];
    }];
}
#pragma mark - Command
- (RACCommand *)fetchRepoCommand {
    if(_fetchRepoCommand == nil) {
        @weakify(self);
        _fetchRepoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self fetchRepoSignal] takeUntil:self.rac_willDeallocSignal];
        }];
    }
    return _fetchRepoCommand;
}
- (RACCommand *)fetchTreeCommand {
	if(_fetchTreeCommand == nil) {
        @weakify(self);
		_fetchTreeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
           return [[self fetchTreeSignal] takeUntil:self.rac_willDeallocSignal];
        }];
	}
	return _fetchTreeCommand;
}
- (RACCommand *)fetchBranchsCommand {
	if(_fetchBranchsCommand == nil) {
        @weakify(self);
		_fetchBranchsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[MGSharedDelegate.client fetchBranchesForRepositoryWithName:self.repo.name
                                                                            owner:self.repo.ownerLogin] collect] doNext:^(NSArray *branchs) {
                @strongify(self);
                self.branches = branchs;
            }]takeUntil:self.rac_willDeallocSignal];
        }];
	}
	return _fetchBranchsCommand;
}

- (RACCommand *)starRepoCommand {
	if(_starRepoCommand == nil) {
        @weakify(self);
        _starRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [MGSharedDelegate.client starRepository:self.repo];
        }];
	}
	return _starRepoCommand;
}

#pragma mark - signal 
- (RACSignal *)fetchRepoSignal{
    @weakify(self);
    return [[[MGApiImpl sharedApiImpl] fetchRepoDetailWithOwner:self.repoOwner repoName:self.repoName] doNext:^(NSDictionary *repoDic) {
        @strongify(self);
        self.repo = [MTLJSONAdapter modelOfClass:[MGRepositoriesModel class]
                              fromJSONDictionary:repoDic error:nil];
        self.currentBranchName = self.repo.defaultBranch;
    }];
}
- (RACSignal *)fetchTreeSignal{
    @weakify(self);
   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[MGSharedDelegate.client fetchTreeForReference:self.currentBranchName
                                           inRepository:self.repo
                                              recursive:NO] subscribeNext:^(OCTTree *fileTree) {
            @strongify(self);
            self.fileTree = fileTree;
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"mode" ascending:NO];
            self.dataSource = [[self.fileTree.entries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
            [subscriber sendNext:RACTuplePack(@YES,@YES,self.dataSource)];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return nil;
   }];
}
- (RACSignal *)fetchDataSignal{
    @weakify(self);
    RACSignal *signal = [self.fetchRepoCommand execute:nil];
    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACSerialDisposable *disposable = [[RACSerialDisposable alloc] init];
        RACDisposable *subscriptionDisposable = [signal subscribeNext:^(id x) {
            
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            @strongify(self);
            RACSignal *signal = [self.fetchTreeCommand execute:nil];
            disposable.disposable = [signal subscribe:subscriber];
        }];
        return [RACDisposable disposableWithBlock:^{
            [disposable dispose];
            [subscriptionDisposable dispose];
        }];
    }];
}
@end
