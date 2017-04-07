//
//  MGCreateRepoViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGCreateRepoViewController.h"
#import "MGCreateRepoViewModel.h"

@interface MGCreateRepoViewController ()

@property (nonatomic, strong) MGCreateRepoViewModel *viewModel;
@property (nonatomic, strong) UITextField *repoNameTextField;
@property (nonatomic, strong) UITextView *repoDescTextView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, assign) BOOL didLayout;



@end

@implementation MGCreateRepoViewController

#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGCreateRepoViewModel *)viewModel;
        self.navigationItem.title = self.viewModel.title;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(dismiss)];
    [self.view addSubview:self.repoNameTextField];
    [self.view addSubview:self.repoDescTextView];
    [self.view addSubview:self.commitButton];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)updateViewConstraints{
    
    if (!self.didLayout) {
        /*
        [self.repoNameTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64+5, 5, 5, 5) excludingEdge:ALEdgeBottom];
        [self.repoNameTextField autoSetDimension:ALDimensionHeight toSize:45];
        [self.repoDescTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.repoNameTextField withOffset:10];
        [self.repoDescTextView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.repoNameTextField];
        [self.repoDescTextView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.repoNameTextField];
        [self.repoDescTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commitButton withOffset:-5];
        [self.commitButton autoSetDimension:ALDimensionHeight toSize:35];
        [self.commitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 5, 5) excludingEdge:ALEdgeTop];
         */
        self.didLayout = YES;
    }
    [super updateViewConstraints];
}
- (void)bindViewModel{
    
    self.commitButton.rac_command = self.viewModel.createRepoCommand;
    
    RAC(self.commitButton,backgroundColor) = [[self.viewModel.canCreateSignal doNext:^(NSNumber *can) {
        self.commitButton.enabled =[can boolValue];
    }]map:^id(NSNumber *can) {
        return [can boolValue]?MGClickedColor:[UIColor lightGrayColor];
    }];
    
    [self.viewModel.createRepoCommand.executionSignals.switchToLatest subscribeError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    } completed:^{
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [SVProgressHUD dismissWithDelay:0.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    [[self.viewModel.createRepoCommand.executing skip:1] subscribeNext:^(NSNumber *execut) {
        if ([execut boolValue]) {
            [SVProgressHUD showWithStatus:@"Creating..."];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}
#pragma mark - Load Data

#pragma mark - Touch Action
- (void)dismiss{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (UITextField *)repoNameTextField{
    
    if (_repoNameTextField == nil) {
        _repoNameTextField = [[UITextField alloc]init];
        _repoNameTextField.borderStyle = UITextBorderStyleLine;
        _repoNameTextField.placeholder = @"Repository Name";
        _repoNameTextField.font = MGFont(14);
        @weakify(self);
        [_repoNameTextField.rac_textSignal subscribeNext:^(NSString *repoName) {
            @strongify(self);
            self.viewModel.repoName = repoName;
        }];
    }
    return _repoNameTextField;
}
- (UITextView *)repoDescTextView{
    
    if (_repoDescTextView == nil) {
        _repoDescTextView = [[UITextView alloc] init];
        _repoDescTextView.font = MGFont(13);
        _repoDescTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _repoDescTextView.layer.borderWidth = 1.f;
        @weakify(self);
        [_repoDescTextView.rac_textSignal subscribeNext:^(NSString *repoDesc) {
            @strongify(self)
            self.viewModel.repoDesc = repoDesc;
        }];
    }
    return _repoDescTextView;
}
- (UIButton *)commitButton{
    
    if (_commitButton == nil) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:@"Create Repo" forState:UIControlStateNormal];
        [_commitButton setTitleColor:MGWhiteColor forState:UIControlStateNormal];
        MGViewCornerRadius(_commitButton, 3.f);
    }
    return _commitButton;
    
}

@end
