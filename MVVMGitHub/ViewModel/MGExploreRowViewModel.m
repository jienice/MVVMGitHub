//
//  MGExploreRowViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/19.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreRowViewModel.h"

NSString *const kExploreRowViewModelTitleKey = @"kExploreRowViewModelTitleKey";
NSString *const kExploreRowViewModelDataSourceKey= @"kExploreRowViewModelDataSourceKey";
NSString *const kExploreRowViewModelRowTypeKey = @"kExploreRowViewModelRowTypeKey";

@interface MGExploreRowViewModel ()

@property (nonatomic, copy, readwrite) NSString *titleString;
@property (nonatomic, strong, readwrite) NSArray *dataSource;
@property (nonatomic, assign, readwrite) MGExploreRowType rowType;

@end

@implementation MGExploreRowViewModel

- (instancetype)initWithParams:(NSDictionary *)params{
    
    if (self = [super init]) {
        NSParameterAssert(![params objectForKey:kExploreRowViewModelTitleKey]);
        NSParameterAssert(![params objectForKey:kExploreRowViewModelDataSourceKey]);
        NSParameterAssert(![params objectForKey:kExploreRowViewModelRowTypeKey]);
        self.titleString = [params objectForKey:kExploreRowViewModelTitleKey];
        self.dataSource = [params objectForKey:kExploreRowViewModelDataSourceKey];
        self.rowType = [[params objectForKey:kExploreRowViewModelRowTypeKey] integerValue];
    }
    return self;
}

@end
