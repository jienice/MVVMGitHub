//
//  MGApiService+MGRepo.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiService.h"

@interface MGApiService (MGRepo)


+ (RACSignal *)fetchRepoDetaiWithOwner:(NSString *)ower repoName:(NSString *)repoName;

@end
