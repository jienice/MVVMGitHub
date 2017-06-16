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

FOUNDATION_EXTERN NSString *const kClassMap;

#pragma mark - MGExplore

FOUNDATION_EXTERN NSString *const kMGExploreCellTypeKey;
FOUNDATION_EXTERN NSString *const kMGExploreCellTitleKey;
FOUNDATION_EXTERN NSString *const kMGExploreCellDataKey;

typedef NS_ENUM(NSInteger,MGExploreCellType){
    
    MGExploreCellTypeOfUser,
    MGExploreCellTypeOfRepo
};

@end
