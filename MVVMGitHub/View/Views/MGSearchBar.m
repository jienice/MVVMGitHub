//
//  MGSearchBar.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchBar.h"

@interface MGSearchBar ()<MGReactiveViewProtocol,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelSearchBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searcBar;
@property (nonatomic, strong, readwrite) RACCommand *cancelSearchCommand;
@property (nonatomic, strong, readwrite) RACCommand *selecteSearchTypeCommand;
@property (nonatomic, strong, readwrite) RACCommand *searchCommand;

@end

@implementation MGSearchBar


#pragma mark - Instance Method
+ (instancetype)showWithFrame:(CGRect)frame{
    MGSearchBar *bar=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]
                      lastObject];
    bar.frame=frame;
    [bar configUI];
    [bar bindViewModel:nil];
    return bar;
}
#pragma mark - Life Cycle
- (void)configUI{
    [self.cancelSearchBtn setTitleColor:MGSystemColor forState:UIControlStateNormal];
    [self.cancelSearchBtn setTitleColor:MGSystemColor forState:UIControlStateHighlighted];
    [self.cancelSearchBtn setTitleColor:MGSystemColor forState:UIControlStateSelected];
    self.searcBar.autocapitalizationType =UITextAutocapitalizationTypeNone;
    self.searcBar.tintColor = MGSystemColor;
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    @weakify(self);
    self.cancelSearchBtn.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    self.selecteSearchTypeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    self.searchCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self.searchCommand execute:nil];
    }];
}
- (NSString *)searchText{
    return self.searcBar.text;
}
- (RACCommand *)cancelSearchCommand{
    return self.cancelSearchBtn.rac_command;
}

@end
