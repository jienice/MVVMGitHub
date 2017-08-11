//
//  TableViewBinder.m
//  ThinTableView
//
//  Created by XingJie on 2017/4/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGTableViewBinder.h"

typedef NS_ENUM(NSInteger,MGTableViewLoadDataType){
    MGTableViewLoading,
    MGTableViewLoadNoData,
    MGTableViewLoadDataFail
};


@interface MGTableViewBinder()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) MGTableViewLoadDataType loadDataType;
@property (nonatomic, strong, readwrite) NSMutableDictionary *indexPathAndCellHeightMap;

@end

@implementation MGTableViewBinder

#pragma mark - Instancetype

+ (instancetype)binderWithTable:(UITableView *)tableView{
    
    MGTableViewBinder *binder = [[MGTableViewBinder alloc]init];
    binder.tableView = tableView;
    binder.dataSource = [NSMutableArray array];
    binder.didSelectedCellCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[RACSignal return:input] deliverOn:RACScheduler.mainThreadScheduler];
    }];
    binder.indexPathAndCellHeightMap = [NSMutableDictionary dictionary];
    binder.loadDataType = MGTableViewLoading;
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
    [dataSouceSignal subscribeNext:^(RACTuple *tuple) {
        NSParameterAssert(tuple.count==3);
        @strongify(self);
        NSLog(@"Next ReloadData");
        NSNumber *isFirstPage = [tuple first];
        NSNumber *isLastPage  = [tuple second];
        NSArray *dataArr = [tuple last];
        [self.tableView headerEndRefresh];
        if (isFirstPage.boolValue){//第一页
            [self.dataSource removeAllObjects];
            [self.indexPathAndCellHeightMap removeAllObjects];
            if (dataArr.count==0) {//第一页且无数据
                self.loadDataType = MGTableViewLoadNoData;
                [self.tableView reloadEmptyDataSet];
            }
        }
        [self.dataSource addObjectsFromArray:dataArr];
        [self.tableView reloadData];
        if (isLastPage.boolValue) {
            NSLog(@"Completed EndRefresh");
            NSLog(@"%s数据全部加载完成，可以统一设置上拉加载的视图",__func__);
            [self.tableView footerEndRefreshWithNoMoreData];
        }else{
            [self.tableView footerEndRefresh];
        }
    }];
}
- (void)setErrors:(RACSignal *)errors{
    
    _errors = errors;
    @weakify(self);
    [_errors subscribeNext:^(NSError *error) {
        @strongify(self);
        NSLog(@"Error EndRefresh");
        self.loadDataType = MGTableViewLoadDataFail;
        [self.tableView reloadEmptyDataSet];
        [self.tableView endRefresh];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAssert(self.cellConfigBlock, @"请先设置Cell复用的Block,-setCellConfigBlock");
    NSString *identifier = self.cellConfigBlock(indexPath);
    id<MGTableViewCellProtocol> cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell bindViewModel:self.dataSource[indexPath.row]];
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = self.cellConfigBlock(indexPath);
    id<MGTableViewCellProtocol>cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc]init];
    }
    NSAssert([cell conformsToProtocol:@protocol(MGTableViewCellProtocol)],
             @"%@ must conform to protocol '-MGTableViewCellProtocol'",identifier);
    if (![_indexPathAndCellHeightMap.allKeys containsObject:indexPath]) {
        _indexPathAndCellHeightMap[indexPath] = [cell performSelector:@selector(cellHeightWithModel:)
                                                           withObject:self.dataSource[indexPath.row]];
    }
    return [(NSNumber *)[self.indexPathAndCellHeightMap objectForKey:indexPath] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.didSelectedCellCommand execute:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    switch (self.loadDataType) {
        case MGTableViewLoadDataFail:{
            return [[NSAttributedString alloc]initWithString:@""
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                               NSForegroundColorAttributeName:[UIColor redColor]}];
        }
            break;
        case MGTableViewLoadNoData:{
            return [[NSAttributedString alloc]initWithString:@"No Data"
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                               NSForegroundColorAttributeName:[UIColor redColor]}];
        }
            break;
        case MGTableViewLoading:{
            return nil;
        }
            break;
        default:
            break;
    }
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIColor whiteColor];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    
    switch (self.loadDataType) {
        case MGTableViewLoadDataFail:{
            return [[NSAttributedString alloc]initWithString:@"重新加载"
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                               NSForegroundColorAttributeName:[UIColor redColor]}];
        }
            
            break;
        case MGTableViewLoadNoData:{
            return [[NSAttributedString alloc]initWithString:@""
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                               NSForegroundColorAttributeName:[UIColor redColor]}];
        }
            break;
        case MGTableViewLoading:{
            return nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    
    switch (self.loadDataType) {
        case MGTableViewLoadDataFail:{
            [self.tableView.mj_header beginRefreshing];
        }
            break;
        case MGTableViewLoadNoData:{
            [MGSharedDelegate.viewModelBased popViewModelAnimated:YES];
        }
            break;
        case MGTableViewLoading:{
            
        }
            break;
        default:
            break;
    }
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    switch (self.loadDataType) {
        case MGTableViewLoadDataFail:{
            return YES;
        }
            break;
        case MGTableViewLoadNoData:{
            return YES;
        }
            break;
        case MGTableViewLoading:{
            return NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Dealloc
- (void)dealloc{
    
    NSLog(@"%s",__func__);
}
@end
