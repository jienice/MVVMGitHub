//
//  MGExploreRowViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/19.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kExploreRowViewModelTitleKey;
extern NSString *const kExploreRowViewModelDataSourceKey;
extern NSString *const kExploreRowViewModelRowTypeKey;

typedef NS_ENUM(NSInteger,MGExploreRowType){
    
    MGExploreRowForPopularUsers,
    MGExploreRowForTrendRepos,
    MGExploreRowForPopularRepos
};

@interface MGExploreRowViewModel : NSObject<MGViewModelProtocol>

@property (nonatomic, copy, readonly) NSString *titleString;
@property (nonatomic, strong, readonly) NSArray *dataSource;//OCTUser、MGRepositoriesModel
@property (nonatomic, assign, readonly) MGExploreRowType rowType;


@end
