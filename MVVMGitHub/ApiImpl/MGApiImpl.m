//
//  MGApiImpl.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

typedef void(^RequestSuccessCallBack)(id responseData);     /**请求成功代码块*/
typedef void(^RequestFailureCallBack)(NSError* error);      /**请求失败代码块*/




#define BASE_URL @"https://api.github.com/"

@interface MGApiImpl ()

@property (nonatomic, copy, readwrite) NSURL *baseUrl;

@end

@implementation MGApiImpl{
    
    AFHTTPClient *_client;
}

#pragma mark - Instancetype Method
+ (instancetype)sharedApiImpl{
    
    static MGApiImpl *apiService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiService = [[MGApiImpl alloc] initWithBaseUrl:[NSURL URLWithString:BASE_URL]];
    });
    [apiService setBaseUrlToDefault];
    return apiService;
}

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl{
    
    if(self = [super init]){
        _baseUrl = baseUrl;
        _client = [[AFHTTPClient alloc]initWithBaseURL:baseUrl];
    }
    return self;
}

- (void)setBaseUrlToDefault{
    
    if (![_client.baseURL.absoluteString isEqualToString:BASE_URL]) {
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
}
#pragma mark -----
- (AFHTTPRequestOperation *)startNetWorkRequestWithHttpMethod:(HTTP_METHOD)httpMethod
                                                         path:(NSString *)path
                                                       params:(NSDictionary *)params
                                                      success:(RequestSuccessCallBack)success
                                                         fail:(RequestFailureCallBack)fail{
    
    if (!params) {
        params = @{};
    }
    NSString *method = [NSString string];
    switch (httpMethod) {
        case POST:
            method = @"POST";
            break;
        case GET:
            method = @"GET";
            break;
        case DELETE:
            method = @"DELETE";
            break;
        case PUT:
            method = @"PUT";
            break;
        default:
            break;
    }
    @weakify(self);
    NSLog(@"URL===%@%@?%@",_client.baseURL,path,[params JSONString]);
    NSMutableURLRequest *request = [_client requestWithMethod:method path:path parameters:params];
    request.timeoutInterval = 30;
    AFHTTPRequestOperation *requestOperation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject jsonValueDecoded]) {
            if (success) {
                success([responseObject jsonValueDecoded]);
            }
        }else{
            if (fail) {
                fail([self handleError:nil]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        error = [self handleError:error];
        if (fail) {
            fail(error);
        }
    }];
    [requestOperation start];
//    NSLog(@"requestOperation --- %@",requestOperation);
    return requestOperation;
}
- (NSError *)handleError:(NSError *)error{
    
    if (error) {
        if (error.code == -1009) {
            return kNetWorkRequestError(kNetworkRequestFailureErrorCode,@"请检查网络连接");
        }else if (error.code == -1001) {
            return kNetWorkRequestError(kNetworkRequestTimeOutErrorCode,@"请求超时");
        }else if (error.code == -1004) {
            return kNetWorkRequestError(kNetworkRequestFailureErrorCode,@"连接服务器失败");
        }
        return error;
    }
    return [NSError errorWithDomain:OCTClientErrorDomain code:9999 userInfo:@{}];
}

#pragma mark -----
- (RACSignal *)startNetWorkRequestWithHttpMethod:(HTTP_METHOD)httpMethod
                                            path:(NSString *)path
                                          params:(NSDictionary *)params{
    
    NSParameterAssert(httpMethod);
    @weakify(self);
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        AFHTTPRequestOperation *requestOperation =
        [self startNetWorkRequestWithHttpMethod:httpMethod path:path params:params success:^(id responseData) {
            [subscriber sendNext:responseData];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [requestOperation cancel];
            NSLog(@"%@ request -disposable",path);
        }];
    }] replayLazily] setNameWithFormat:@"-starNetWorkRequest %@/%@",_client.baseURL,path];
    //replayLazily,signal must be subscribed before you start network request.
    return signal;
}
@end


