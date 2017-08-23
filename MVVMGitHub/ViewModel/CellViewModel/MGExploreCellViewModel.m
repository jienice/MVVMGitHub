//
//  MGExploreCellViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/5/25.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreCellViewModel.h"
#import "MGRepoDetailViewModel.h"
#import "MGProfileViewModel.h"

@interface MGExploreCellViewModel ()

@property (nonatomic, assign, readwrite) MGExploreCellType cellType;
@property (nonatomic, strong, readwrite) NSArray *cellData;
@property (nonatomic, copy, readwrite) NSString *cellTitle;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, strong, readwrite) RACCommand *itemClickedCommand;
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
- (RACCommand *)itemClickedCommand {
	if(_itemClickedCommand == nil) {
        @weakify(self);
		_itemClickedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
            @strongify(self);
            switch (self.cellType) {
                case MGExploreCellTypeOfRepo:{
                    MGRepositoriesModel *repo = self.cellData[indexPath.item];
                    MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]
                                                         initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,
                                                                          kRepoDetailParamsKeyForRepoName:repo.name}];
                    [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
                }
                    break;
                case MGExploreCellTypeOfUser:{
                    OCTUser *user = self.cellData[indexPath.row];
                    MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                                   initWithParams:@{kProfileOfUserLoginName:user.login,
                                                                    kProfileIsShowOnTabBar:@NO}];
                    [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
                }
                    break;
                default:
                    break;
            }
            return [RACSignal empty];
        }];
	}
	return _itemClickedCommand;
}

@end
