//
//  MGExploreCellViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/5/25.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreCellViewModel.h"

@interface MGExploreCellViewModel ()

@property (nonatomic, assign, readwrite) MGExploreCellType cellType;
@property (nonatomic, strong, readwrite) NSArray *cellData;
@property (nonatomic, copy, readwrite) NSString *cellTitle;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@end


@implementation MGExploreCellViewModel

- (instancetype)initWithParams:(NSDictionary *)params{
    
    if (self=[super init]) {
        NSParameterAssert(params[kMGExploreCellTypeKey]);
        NSParameterAssert(params[kMGExploreCellTitleKey]);
        NSParameterAssert(params[kMGExploreCellDataKey]);
        self.cellType = (MGExploreCellType) [params[kMGExploreCellTypeKey] integerValue];
        self.cellData = params[kMGExploreCellDataKey];
        self.cellTitle = params[kMGExploreCellTitleKey];
        self.params = params;
    }
    return self;
}
- (void)initialize{}
@end
