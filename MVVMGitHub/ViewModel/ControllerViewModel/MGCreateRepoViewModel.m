//
//  MGCreateRepoViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGCreateRepoViewModel.h"


@interface MGCreateRepoViewModel()

@property (nonatomic, strong, readwrite) RACSignal *canCreateSignal;

@end

@implementation MGCreateRepoViewModel


- (void)initialize{
    
    self.canCreateSignal = [RACSignal combineLatest:@[RACObserve(self, repoName),RACObserve(self,repoDesc)]
                                             reduce:^id(NSString *repoName,NSString*repoDesc){
        return @(repoName.length>0);
    }];
    
    
    self.createRepoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[MGSharedDelegate.client createRepositoryWithName:self.repoName
                                                      description:self.repoDesc private:self.isPrivate]
                takeUntil:self.rac_willDeallocSignal];
    }];
}
@end
