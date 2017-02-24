//
//  MGApiService+MGSearch.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/24.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiService.h"

@interface MGApiService (MGSearch)

//stars, forks, or updated. Default: results are sorted by best match.
//asc or desc. Default: desc

+ (RACSignal *)searchRepositoriesWithKeyWord:(NSString *)keyWord
                                    language:(NSString *)language
                                        sort:(NSString *)sort
                                       order:(NSString *)order;


+ (RACSignal *)searchUserWithKeyWord:(NSString *)keyWord
                            language:(NSString *)language
                                sort:(NSString *)sort
                               order:(NSString *)order;

@end
