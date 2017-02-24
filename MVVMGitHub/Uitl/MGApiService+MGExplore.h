//
//  MGApiService+MGExplore.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiService.h"

@interface MGApiService (MGExplore)

+ (RACSignal *)fetchTrendReposSince:(NSString *)since language:(NSString *)language;


+ (RACSignal *)fetchShowcases;


@end
