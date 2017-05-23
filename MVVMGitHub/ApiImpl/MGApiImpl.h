//
//  MGApiImpl.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HTTP_METHOD){
    
    POST,
    GET,
    PUT,
    DELETE
};

FOUNDATION_EXTERN NSInteger const kNetworkRequestFailureErrorCode;
FOUNDATION_EXTERN NSInteger const kNetworkRequestTimeOutErrorCode;
FOUNDATION_EXTERN NSInteger const kNetworkRequestBackErrorMessageErrorCode;
FOUNDATION_EXTERN NSInteger const kNetworkRequestTimeoutInterval;
FOUNDATION_EXTERN NSString const *kErrorMessageKey;


@interface MGApiImpl : NSObject

@property (nonatomic, copy, readonly) NSURL *baseUrl;

+ (instancetype)sharedApiImpl;

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;

/**
 Invoke this method ,you can create an network request with method like 'POST','GET'
 this method will return one signal
 */
- (RACSignal *)startNetWorkRequestWithHttpMethod:(HTTP_METHOD)httpMethod
                                            path:(NSString *)path
                                          params:(NSDictionary *)params;




@end
