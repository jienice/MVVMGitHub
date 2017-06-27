//
//  MGSearchResultModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSearchResultModel : NSObject

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) NSNumber *incomplete_results;

@property (nonatomic, assign) NSInteger total_count;



@end
