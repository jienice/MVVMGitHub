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
@property (nonatomic, assign) NSInteger page;

/**
 tableView's dataSource
 */
@property (nonatomic, strong) NSArray *dataSource;

/**
 user did selected tableView row will invoke this command
 */
@property (nonatomic, strong) RACCommand *didSelectedRowCommand;

/**
 invoke this command fetch data from service
 */
@property (nonatomic, strong) RACCommand *fetchDataFromServiceCommand;

/**
 cancel fetch data request signal
 if you don't set before you invoke -fetchDataFromServiceCommand, 
 this signal will be set to default with -rac_willDeallocSignal
 */
@property (nonatomic, strong) RACSignal *cancelFetchDataSignal;


@optional
- (RACSignal *)fetchDataFromServiceWithPage:(NSInteger)page;


@end
