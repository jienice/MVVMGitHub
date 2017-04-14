//
//  MGApiImpl+MGRepo.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

@interface MGApiImpl (MGRepo)
- (RACSignal *)fetchRepoDetaiWithOwner:(NSString *)ower repoName:(NSString *)repoName;
@end
