//
//  MGEventsViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/10.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGEventsViewModel.h"
#import "MGEvent.h"

@implementation MGEventsViewModel

@synthesize page = _page;
@synthesize dataSource = _dataSource;
@synthesize didSelectedRowCommand = _didSelectedRowCommand;
@synthesize fetchDataFromServiceCommand = _fetchDataFromServiceCommand;

- (void)initialize{
    
    
}

@end
