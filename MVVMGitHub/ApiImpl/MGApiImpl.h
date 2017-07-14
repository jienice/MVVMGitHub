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


@interface MGApiImpl : NSObject

/**
 *  使用自定义的网络请求，请求列表数据时不进行分页。
 *  若添加‘per_page’,'page'参数返回的数据中不包含‘total’、‘pageNumber’之类的字段，无法确定是否加载完毕。
 */




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
