//
//  MGConst.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 全局使用字符串
 */
@interface MGConst : NSObject

extern NSString *const kClassMap;

#pragma mark - MGExplore

extern NSString *const kMGExploreCellTypeKey;
extern NSString *const kMGExploreCellTitleKey;
extern NSString *const kMGExploreCellDataKey;

#pragma mark - Error

extern NSString *const MGCocoaErrorDomain;

#pragma mark - Network
extern NSInteger const kNetworkRequestFailureErrorCode;
extern NSInteger const kNetworkRequestTimeOutErrorCode;
extern NSInteger const kNetworkRequestBackErrorMessageErrorCode;
extern NSInteger const kNetworkRequestTimeoutInterval;
extern NSString const *kErrorMessageKey;


#pragma mark - search
extern NSString *const kSearchBarPlaceholderString;



@end
