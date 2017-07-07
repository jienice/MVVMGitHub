//
//  MGSearchBar.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/6/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSearchBar.h"
#import <pop/POP.h>

@interface MGSearchBar ()<MGReactiveViewProtocol,UITextFieldDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchBtn;

@end

@implementation MGSearchBar


#pragma mark - Instance Method
+ (instancetype)showWithFrame:(CGRect)frame{
    
    MGSearchBar *bar=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]
                      lastObject];
    bar.frame=frame;
    bar.searchBar.placeholder = @"Please Input Repo's Or User's Name";
    bar.searchBar.autocapitalizationType =UITextAutocapitalizationTypeNone;
    bar.searchBar.tintColor = MGClickedColor;
    bar.searchBar.delegate = bar;
    [bar bindViewModel:nil];
    [bar.cancelSearchBtn setTitleColor:MGClickedColor forState:UIControlStateNormal];
    [bar.cancelSearchBtn setTitleColor:MGClickedColor forState:UIControlStateHighlighted];
    [bar.cancelSearchBtn setTitleColor:MGClickedColor forState:UIControlStateSelected];
    return bar;
}
#pragma mark - Life Cycle

#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    
    [self.cancelSearchBtn addTarget:self.searchBar
                             action:@selector(resignFirstResponder)
                   forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextSignal = [[self rac_signalForSelector:@selector(searchBar:textDidChange:)
                                        fromProtocol:@protocol(UISearchBarDelegate)]
                         map:^NSString *(RACTuple *value) {
        return (NSString *)[value last];
    }];
    
    _becomeFirstResponder = [self rac_signalForSelector:@selector(searchBarTextDidBeginEditing:)
                                           fromProtocol:@protocol(UISearchBarDelegate)];

    _resignFirstResponder = [self rac_signalForSelector:@selector(searchBarTextDidEndEditing:)
                                           fromProtocol:@protocol(UISearchBarDelegate)];

    @weakify(self);
    _didClickedSearchBtn  = [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:)
                                          fromProtocol:@protocol(UISearchBarDelegate)] doNext:^(id x) {
        @strongify(self);
        [self.searchBar resignFirstResponder];
    }];
    
    _startInputCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *isStart) {
        if ([isStart boolValue]) {
            [self.searchBar becomeFirstResponder];
        }else{
            [self.searchBar resignFirstResponder];
        }
        return [RACSignal empty];
    }];
}
#pragma mark - Touch Action

#pragma mark - UITextFieldDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    NSString *beginEditing = @"BeginEditing";
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.fromValue = [NSValue valueWithCGRect:searchBar.frame];
    spring.toValue = [NSValue valueWithCGRect:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y,
                                                         self.width-42, CGRectGetHeight(searchBar.frame))];
    [spring setCompletionBlock:^(POPAnimation *anim, BOOL complete){
        [searchBar pop_removeAnimationForKey:beginEditing];
    }];
    [searchBar pop_addAnimation:spring forKey:beginEditing];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    NSString *endEditing = @"EndEditing";
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.fromValue = [NSValue valueWithCGRect:searchBar.frame];
    spring.toValue = [NSValue valueWithCGRect:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y,
                                                         self.width, CGRectGetHeight(searchBar.frame))];
    [spring setCompletionBlock:^(POPAnimation *anim, BOOL complete){
        [searchBar pop_removeAnimationForKey:endEditing];
    }];
    [searchBar pop_addAnimation:spring forKey:endEditing];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
}

@end
