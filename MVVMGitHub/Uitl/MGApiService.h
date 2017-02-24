//
//  MGApiService.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,HTTP_METHOD){
    
    POST,
    GET
};

@interface MGApiService : NSObject

//
///**
// Invoke this method ,you can create an network request with method like 'POST','GET','DELETE'
// this method will return one signal
// 
// */
+ (RACSignal *)starNetWorkRequestWithHttpMethod:(HTTP_METHOD)httpMethod
                                        baseUrl:(NSString *)baseUrl
                                           path:(NSString *)path
                                         params:(NSDictionary *)params;

@end
