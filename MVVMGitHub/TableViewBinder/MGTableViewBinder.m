//
//  TableViewBinder.m
//  ThinTableView
//
//  Created by XingJie on 2017/4/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGTableViewBinder.h"

@interface MGTableViewBinder()
<UITableViewDelegate,UITableViewDataSource,
DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSouce;


@end

@implementation MGTableViewBinder

#pragma mark - Instancetype
+ (instancetype)binderWithTable:(UITableView *)tableView{
    
    MGTableViewBinder *binder = [[MGTableViewBinder alloc]init];
    binder.tableView = tableView;
    binder.tableView.delegate = binder;
    binder.tableView.dataSource = binder;
    binder.tableView.emptyDataSetSource = binder;
    binder.tableView.emptyDataSetDelegate = binder;
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
    [dataSouceSignal subscribeNext:^(NSArray *x) {
        @strongify(self);
        self.dataSouce = [x mutableCopy];
        NSLog(@"self.dataSouce === %@",x);
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        NSLog(@"%s数据请求出现错误",__func__);
        @strongify(self);
        [self.dataSouce removeAllObjects];
        [self.tableView reloadData];
    } completed:^{
        NSLog(@"%s数据全部加载完成，可以统一设置上拉加载的视图",__func__);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAssert(self.cellConfigBlock, @"请先设置Cell复用的Block,-setCellConfigBlock");
    NSString *identifier = self.cellConfigBlock(indexPath);
    id<MGReactiveViewProtocol> cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                      forIndexPath:indexPath];
    NSAssert([cell conformsToProtocol:@protocol(MGReactiveViewProtocol)],@"必须遵循协议-TableViewProtocol");
    [cell bindViewModel:self.dataSouce[indexPath.row]];
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAssert(self.heightConfigBlock, @"请先设置Cell高度的Block,-setHeightConfigBlock");
    return self.heightConfigBlock(indexPath);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cellSelectedBlock) {
        self.cellSelectedBlock(self.dataSouce[indexPath.row],indexPath);
    }
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
#pragma mark - DZNEmptyDataSetDelegate

@end
