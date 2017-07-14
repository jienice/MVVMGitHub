//
//  TableViewBinder.h
//  ThinTableView
//
//  Created by XingJie on 2017/4/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NSString *(^String_IndexPathBlock)(NSIndexPath *IndexPath);


@interface MGTableViewBinder : NSObject
<UITableViewDelegate,UITableViewDataSource,
DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

+ (instancetype)binderWithTable:(UITableView *)tableView;

/**
 设置数据信号源，传值为RACTuple(是否为第一页'NSNumber',是否为最后一页'NSNumber'，数据源'NSArray')
 */
@property (nonatomic, strong, setter=setDataSouceSignal:) RACSignal *dataSourceSignal;
@property (nonatomic, strong, setter=setErrors:) RACSignal *errors;

@property (nonatomic, copy) String_IndexPathBlock cellConfigBlock;

@property (nonatomic, strong) NSArray<Class> *reuseNoXibCellClass;
@property (nonatomic, strong) NSArray<Class> *reuseXibCellClass;

@property (nonatomic, strong) RACCommand *didSelectedCellCommand;

@property (nonatomic, strong, readonly) NSMutableDictionary *indexPathAndCellHeightMap;

- (void)setCellConfigBlock:(String_IndexPathBlock)cellConfigBlock;


@end




