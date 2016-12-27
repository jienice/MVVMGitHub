//
//  MGTableViewModelProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/26.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGTableViewModelProtocol <NSObject>


@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) RACCommand *didSelectedRowCommand;

@property (nonatomic, strong) RACCommand *fetchDataFromServiceCommand;

@property (nonatomic, strong) RACSignal *cancelFetchDataSignal;


- (RACSignal *)fetchDataFromServiceWithPage:(NSInteger)page;






@end
