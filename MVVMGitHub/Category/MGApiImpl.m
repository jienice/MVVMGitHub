//
//  MGApiImpl.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"


@interface MGApiImpl ()


@end

@implementation MGApiImpl

+ (instancetype)sharedApiService{
    
    static MGApiImpl *apiService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiService = [[MGApiImpl alloc]init];
    });
    return apiService;
}

- (RACSignal *)starNetWorkRequestWithHttpMethod:(HTTP_METHOD)httpMethod
                                        baseUrl:(NSURL *)baseUrl
                                           path:(NSString *)path
                                         params:(NSDictionary *)params{
    
    NSParameterAssert(httpMethod);
    NSString *method;
    switch (httpMethod) {
        case POST:
            method = @"POST";
            break;
        case GET:
            method = @"GET";
            break;
        default:
            break;
    }
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseUrl];
    NSMutableURLRequest *request = [client requestWithMethod:method path:path parameters:params];
    request.timeoutInterval = 30;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                [[RACScheduler mainThreadScheduler] schedule:^{
                                                    if (error) {
                                                        [subscriber sendError:error];
                                                    }else{
                                                        [subscriber sendNext:[data mj_JSONObject]];
                                                        [subscriber sendCompleted];
                                                    }
                                                }];
                                            }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"%@ request -disposable",path);
            [task cancel];
        }];
    }] replayLazily] setNameWithFormat:@"-starNetWorkRequest %@/%@",baseUrl,path];
    //replayLazily,signal must be subscribed before you start network request.
    return signal;
}

@end
