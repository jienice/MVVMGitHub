//
//  MGLoginViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGLoginViewController.h"
#import "MGLoginViewModel.h"

@interface MGLoginViewController ()

@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *passWordText;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) MGLoginViewModel *viewModel;

@end

@implementation MGLoginViewController

- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    if (self= [super init]) {
        self.viewModel = (MGLoginViewModel *)viewModel;
    }
    return self;
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
}

- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    RAC(self.loginButton,backgroundColor) = [[self.viewModel.canLoginSignal doNext:^(NSNumber *value) {
       @strongify(self);
       [self.loginButton setEnabled:[value boolValue]];
    }] map:^id(NSNumber *value) {
        return [value boolValue]?MGSystemColor:MGNormalColor;
    }];

    [[[[self.viewModel.loginCommand.executing filter:^BOOL(NSNumber *isExecut) {
        return isExecut.boolValue;
    }] deliverOn:RACScheduler.mainThreadScheduler] doNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }]subscribeNext:^(id x) {
        [SVProgressHUD show];
    }];

    [[[self.viewModel.loginCommand.executionSignals.switchToLatest deliverOn:RACScheduler.mainThreadScheduler] doNext:^(id x) {
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    }]subscribeNext:^(id x) {
        MGViewModel *mainViewModel = [[NSClassFromString(@"MGMainViewModel") alloc]initWithParams:nil];
        [MGSharedDelegate.viewModelBased pushViewModel:mainViewModel animated:YES];
    }];

    [self.viewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
- (void)configUI{
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:self.userNameText];
    [self.view addSubview:self.passWordText];
    [self.view addSubview:self.loginButton];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)updateViewConstraints{
    [self.userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(200);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameText.mas_bottom).offset(3);
        make.left.mas_equalTo(self.userNameText.mas_left);
        make.right.mas_equalTo(self.userNameText.mas_right);
        make.height.mas_equalTo(@[self.userNameText.mas_height,self.loginButton.mas_height]);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passWordText.mas_bottom).offset(10);
        make.left.mas_equalTo(self.userNameText.mas_left);
        make.right.mas_equalTo(self.userNameText.mas_right);
    }];
    [super updateViewConstraints];
}
#pragma mark - Lazy Load
- (UITextField *)userNameText{
    
    if (_userNameText == nil) {
        _userNameText = [[UITextField alloc]init];
        _userNameText.backgroundColor = MGWhiteColor;
        _userNameText.font = MGFont(14);
        _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameText.autocapitalizationType =UITextAutocapitalizationTypeNone;
        _userNameText.placeholder  = @"Please input your github userName!";
        @weakify(self);
        [_userNameText. rac_textSignal subscribeNext:^(NSString *userName) {
            @strongify(self);
            self.viewModel.userName = userName;
        }];
        if ([SAMKeychain mg_rawlogin].isExist) {
            [_userNameText setText:[SAMKeychain mg_rawlogin]];
            [_userNameText sendActionsForControlEvents:UIControlEventValueChanged];
        }
        _userNameText.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _userNameText;
}
- (UITextField *)passWordText{
    
    if (_passWordText == nil) {
        _passWordText = [[UITextField alloc]init];
        _passWordText.backgroundColor = MGWhiteColor;
        _passWordText.font = MGFont(14);
        _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordText.autocapitalizationType =UITextAutocapitalizationTypeNone;
        _passWordText.placeholder  = @"Please input your password!";
        _passWordText.secureTextEntry = YES;
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
