//
//  TableViewBinder.h
//  ThinTableView
//
//  Created by XingJie on 2017/4/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NSString*(^ReuseidentifierConfigBlock)(NSIndexPath *indexPath);
typedef CGFloat(^HeightConfigBlock)(NSIndexPath *indexPath);
typedef void(^CellSelectedBlock)(id object,NSIndexPath *indexPath);


@interface MGTableViewBinder : NSObject


+ (instancetype)binderWithTable:(UITableView *)tableView;

@property (nonatomic, copy) ReuseidentifierConfigBlock cellConfigBlock;
@property (nonatomic, copy) HeightConfigBlock heightConfigBlock;
@property (nonatomic, copy) CellSelectedBlock cellSelectedBlock;

@property (nonatomic, strong) NSArray<Class> *reuseNoXibCellClass;
@property (nonatomic, strong) NSArray<Class> *reuseXibCellClass;


- (void)setCellConfigBlock:(ReuseidentifierConfigBlock)cellConfigBlock;
- (void)setHeightConfigBlock:(HeightConfigBlock)heightConfigBlock;
- (void)setCellSelectedBlock:(CellSelectedBlock)cellSelectedBlock;
- (void)setDataSouceSignal:(RACSignal *)dataSouceSignal;

@end




