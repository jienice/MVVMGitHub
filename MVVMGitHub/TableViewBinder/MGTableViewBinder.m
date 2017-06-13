//
//  TableViewBinder.m
//  ThinTableView
//
//  Created by XingJie on 2017/4/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGTableViewBinder.h"

@interface MGTableViewBinder()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong, readwrite) NSArray<Class> *reuseNoXibCellClass;
//@property (nonatomic, strong, readwrite) NSArray<Class> *reuseXibCellClass;
//@property (nonatomic, strong, readwrite) RACSignal *dataSourceSignal;

@end

@implementation MGTableViewBinder

#pragma mark - Instancetype

+ (instancetype)binderWithTable:(UITableView *)tableView{
    
    MGTableViewBinder *binder = [[MGTableViewBinder alloc]init];
    binder.tableView = tableView;
    binder.dataSource = [NSMutableArray array];
    binder.didSelectedCellCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
    return binder;
}
#pragma mark - setter
- (void)setReuseXibCellClass:(NSArray *)reuseXibCellClass{
    
    _reuseXibCellClass = reuseXibCellClass;
    for (Class className in _reuseXibCellClass) {
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(className) bundle:nil]
             forCellReuseIdentifier:NSStringFromClass(className)];
    }
}
- (void)setReuseNoXibCellClass:(NSArray *)reuseNoXibCellClass{
    
    _reuseNoXibCellClass = reuseNoXibCellClass;
    for (Class className in _reuseNoXibCellClass) {
        [self.tableView registerClass:className
               forCellReuseIdentifier:NSStringFromClass(className)];
    }
}
- (void)setDataSouceSignal:(RACSignal *)dataSouceSignal{
    
    @weakify(self);
    _dataSourceSignal = dataSouceSignal;
    [dataSouceSignal subscribeNext:^(id x) {
        [x subscribeNext:^(RACTuple *tuple) {
            NSLog(@"Next ReloadData");
            NSParameterAssert(tuple.count==2);
            @strongify(self);
            NSNumber *isFirstPage = [tuple first];
            NSArray *dataArr = [tuple last];
            if (isFirstPage.boolValue){
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:dataArr];
            [self.tableView reloadData];
            [self.tableView headerEndRefresh];
            [self.tableView footerEndRefresh];
        } error:^(NSError *error){
            @strongify(self);
            NSLog(@"Error EndRefresh");
            [self.tableView endRefresh];
        } completed:^{
            NSLog(@"Completed EndRefresh");
            @strongify(self);
            [self.tableView endRefresh];
            [self.tableView footerEndRefreshWithNoMoreData];
            NSLog(@"%s数据全部加载完成，可以统一设置上拉加载的视图",__func__);
        }];
    }];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAssert(self.cellConfigBlock, @"请先设置Cell复用的Block,-setCellConfigBlock");
    NSString *identifier = self.cellConfigBlock(indexPath);
    id<MGReactiveViewProtocol> cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                      forIndexPath:indexPath];
    NSAssert([cell conformsToProtocol:@protocol(MGReactiveViewProtocol)],@"必须遵循协议-TableViewProtocol");
    [cell bindViewModel:self.dataSource[indexPath.row]];
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAssert(self.heightConfigBlock, @"请先设置Cell高度的Block,-setHeightConfigBlock");
    return self.heightConfigBlock(indexPath);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.didSelectedCellCommand execute:indexPath];
}
#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc]initWithString:@"测试"
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                       NSForegroundColorAttributeName:[UIColor redColor]}];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIColor blueColor];
}
@end
