//
//  TableViewBinder.h
//  ThinTableView
//
//  Created by XingJie on 2017/4/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MGTableViewBinder : NSObject
<UITableViewDelegate,UITableViewDataSource,
DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

+ (instancetype)binderWithTable:(UITableView *)tableView;

@property (nonatomic, copy) string_IndexPathBlock cellConfigBlock;
@property (nonatomic, copy) float_IndexPathBlock heightConfigBlock;
@property (nonatomic, strong) RACCommand *didSelectedCellCommand;

@property (nonatomic, strong) NSArray<Class> *reuseNoXibCellClass;
@property (nonatomic, strong) NSArray<Class> *reuseXibCellClass;


- (void)setCellConfigBlock:(string_IndexPathBlock)cellConfigBlock;
- (void)setHeightConfigBlock:(float_IndexPathBlock)heightConfigBlock;

/**
 *  设置数据信号源
 *
 *  @param dataSouceSignal 传值为RACTuple(是否为第一页'NSNumber',数据源'NSArray')
 */
- (void)setDataSouceSignal:(RACSignal *)dataSouceSignal;

@end




