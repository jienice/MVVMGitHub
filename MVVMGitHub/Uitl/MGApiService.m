//
//  MGApiService.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGApiService.h"

@implementation MGApiService

+ (RACSignal *)starNetWorkRequestWithHttpMethod:(NSString *)httpMethod
                                        baseUrl:(NSString *)url
                                           path:(NSString *)path
                                         params:(NSDictionary *)params{
    
    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSMutableURLRequest *request = [client requestWithMethod:httpMethod path:path parameters:params];
        [request setTimeoutInterval:30];
        AFHTTPRequestOperation *operation =
        [client HTTPRequestOperationWithRequest:request
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ error desc:%@",error,error.localizedDescription);
            [subscriber sendError:error];
        }];
        [operation start];
        return nil;
    }];
    
    
}



@end
