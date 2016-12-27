//
//  MGLoginViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGLoginViewController.h"
#import "MGLoginViewModel.h"
#import "MGMainViewController.h"    
#import "MGMainViewModel.h"
@interface MGLoginViewController ()

@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *passWordText;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) MGLoginViewModel *viewModel;

@property (nonatomic, assign) BOOL didLayout;


@end

@implementation MGLoginViewController

- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self= [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.userNameText];
    [self.view addSubview:self.passWordText];
    [self.view addSubview:self.loginButton];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)bindViewModel{
    
    @weakify(self);
    RAC(self.loginButton,backgroundColor) = [[self.viewModel.canLoginSignal doNext:^(NSNumber *value) {
       @strongify(self);
       [self.loginButton setEnabled:[value boolValue]];
    }] map:^id(NSNumber *value) {
        return [value boolValue]?[UIColor blueColor]:[UIColor lightGrayColor];
    }];
    [[self.viewModel.loginCommand.executing skip:1] subscribeNext:^(NSNumber *isExecut) {
        if ([isExecut boolValue]) {
            [SVProgressHUD showWithStatus:@"loging..."];
        }else{
            [SVProgressHUD dismissHUD];
        }
    }];
    
    [[[self.viewModel.loginSuccessCommand executionSignals]switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        MGMainViewModel *mainViewModel = [[MGMainViewModel alloc]initWithParams:nil];
        MGMainViewController *main = [[MGMainViewController alloc]initWithViewModel:mainViewModel];
        [self.navigationController pushViewController:main animated:YES];
    }];

}
- (void)updateViewConstraints{
    
    if (!self.didLayout) {
        [self.userNameText autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(200, 10, 0, 10) excludingEdge:ALEdgeBottom];
        [self.userNameText autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.passWordText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userNameText withOffset:10];
        [self.passWordText autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userNameText];
        [self.passWordText autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.userNameText];
        [self.passWordText autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.userNameText];
        
        [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passWordText withOffset:10];
        [self.loginButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userNameText];
        [self.loginButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.userNameText];
        [self.loginButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.userNameText];
        [self.loginButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.userNameText];

        self.didLayout = YES;
    }
    [super updateViewConstraints];
}
#pragma mark - lazy load
- (UITextField *)userNameText{
    
    if (_userNameText == nil) {
        _userNameText = [[UITextField alloc]init];
        _userNameText.backgroundColor = [UIColor whiteColor];
        _userNameText.font = MGFont(14);
        _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameText.placeholder  = @"Please input your github userName!";
        _userNameText.text = @"jie.xing.personal@gmail.com";
        [_userNameText. rac_textSignal subscribeNext:^(NSString *userName) {
            self.viewModel.userName = userName;
        }];
        _userNameText.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _userNameText;
}
- (UITextField *)passWordText{
    
    if (_passWordText == nil) {
        _passWordText = [[UITextField alloc]init];
        _passWordText.backgroundColor = [UIColor whiteColor];
        _passWordText.font = MGFont(14);
        _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordText.placeholder  = @"Please input your password!";
        _passWordText.secureTextEntry = YES;
        _passWordText.text = @"xHyUWpXFbvrQarDFjW2uKDmi";
        [_passWordText. rac_textSignal subscribeNext:^(NSString *passWord) {
            self.viewModel.passWord = passWord;
        }];
    }
    return _passWordText;
}
- (UIButton *)loginButton{
    
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"login" forState:UIControlStateNormal];
        @weakify(self);
        [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel.loginCommand execute:nil];
        }];
        MGViewCornerRadius(_loginButton, 3);
    }
    return _loginButton;
}
@end
