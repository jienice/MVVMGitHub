//
//  MGTableViewModelProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/26.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGTableViewModelProtocol <NSObject>
/**
 current page number
 */
@property (nonatomic, assign, readonly) NSInteger page;

/**
 tableView's dataSource
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 user did selected tableView row will invoke this command
 */
@property (nonatomic, strong, readonly) RACCommand *didSelectedRowCommand;


@optional
- (RACSignal *)fetchDataFromServiceWithPage:(NSInteger)page;


@end
