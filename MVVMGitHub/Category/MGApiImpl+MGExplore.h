//
//  MGApiImpl+MGExplore.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

@interface MGApiImpl (MGExplore)

- (RACSignal *)fetchTrendReposSince:(NSString *)since language:(NSString *)language;


- (RACSignal *)fetchShowcases;

@end
