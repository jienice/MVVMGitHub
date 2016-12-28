//
//  MGApiService.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGApiService : NSObject

+ (RACSignal *)starNetWorkRequestWithHttpMethod:(NSString *)httpMethod
                                        baseUrl:(NSString *)url
                                           path:(NSString *)path
                                         params:(NSDictionary *)params;

@end
