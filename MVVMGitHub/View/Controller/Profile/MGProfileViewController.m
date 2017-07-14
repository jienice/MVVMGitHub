//
//  MGUserViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGProfileViewController.h"
#import "MGProfileViewModel.h"
#import "MGProfileHeaderView.h"
#import "MGUser.h"
#import "MGTableViewCell.h"
#import "MGFollowerViewModel.h"
#import "MGFollowingViewModel.h"
#import "MGRepositoryViewModel.h"

@interface MGProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MGProfileViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MGProfileHeaderView *headerView;

@end

@implementation MGProfileViewController


#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    
    if (self = [super init]) {
        self.viewModel = (MGProfileViewModel *)viewModel;
    }
    return self;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
    [self.viewModel.fetchDataFromServiceCommand execute:nil];
}
- (void)bindViewModel:(id)viewModel{

    @weakify(self);
    [[RACObserve(self, viewModel.user) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView bindViewModel:x];
        [self.tableView reloadData];
    }];
    
    [self.headerView.didClickedCategoryCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *typeNumber) {
        @strongify(self);
        MGProfileCategoryType type = (MGProfileCategoryType) typeNumber.integerValue;
        switch (type) {
            case MGProfileCategoryTypeOfFollower:{
                MGFollowerViewModel *follower =
                [[MGFollowerViewModel alloc]initWithParams:@{kProfileOfUserLoginName:self.viewModel.loginName}];
                [MGSharedDelegate.viewModelBased pushViewModel:follower animated:YES];
                NSLog(@"MGProfileCategoryTypeOfFollower - %s",__func__);
            }
                break;
            case MGProfileCategoryTypeOfFollowing:{
                MGFollowingViewModel *following =
                [[MGFollowingViewModel alloc]initWithParams:@{kProfileOfUserLoginName:self.viewModel.loginName}];
                [MGSharedDelegate.viewModelBased pushViewModel:following animated:YES];
                NSLog(@"MGProfileCategoryTypeOfFollowing - %s",__func__);
            }
                break;
            case MGProfileCategoryTypeOfPublicRepo:{
                MGRepositoryViewModel *repo =
                [[MGRepositoryViewModel alloc]initWithParams:@{kListRepositoriesUserName:self.viewModel.loginName}];
                [MGSharedDelegate.viewModelBased pushViewModel:repo animated:YES];
                NSLog(@"MGProfileCategoryTypeOfPublicRepo - %s",__func__);
            }
                break;
            default:
                break;
        }
    }];
}
- (void)configUI{
    
    self.navigationItem.title = self.viewModel.title;
    self.view.backgroundColor = MGWhiteColor;
    if ([self.navigationController.navigationBar isHidden]) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    if (self.navigationController.childViewControllers.count>1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];
    }
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, MGSCREEN_WIDTH, 250);
    [self.view addSubview:self.tableView];
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 4;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MGTableViewCell class])];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.text.text = self.viewModel.user.company.isExist?self.viewModel.user.company:@"Not Set";
            cell.image.image = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconLocation]
                                                  backgroundColor:MGWhiteColor
                                                        iconColor:MGBlackColor
                                                        iconScale:1.0
                                                          andSize:CGSizeMake(15, 15)];
        }else if (indexPath.row == 1) {
            cell.text.text = self.viewModel.user.location.isExist?self.viewModel.user.location:@"Not Set";
            cell.image.image = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconLocation]
                                                  backgroundColor:MGWhiteColor
                                                        iconColor:MGBlackColor
                                                        iconScale:1.0
                                                          andSize:CGSizeMake(15, 15)];
        }else if (indexPath.row == 2) {
            cell.text.text = self.viewModel.user.blog.isExist?self.viewModel.user.blog:@"Not Set";
            cell.image.image = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconLink]
                                                  backgroundColor:MGWhiteColor
                                                        iconColor:MGBlackColor
                                                        iconScale:1.0
                                                          andSize:CGSizeMake(15, 15)];
        }else if (indexPath.row == 3) {
            cell.text.text = self.viewModel.user.email.isExist?self.viewModel.user.email:@"Not Set";
            cell.image.image = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconMail]
                                                  backgroundColor:MGWhiteColor
                                                        iconColor:MGBlackColor
                                                        iconScale:1.0
                                                          andSize:CGSizeMake(15, 15)];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.text.text = @"Contribution Activity";
            cell.image.image = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconRepoPush]
                                              backgroundColor:MGWhiteColor
                                                    iconColor:MGBlackColor
                                                    iconScale:1.0
                                                      andSize:CGSizeMake(15, 15)];
            
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark - Lazy Load
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MGTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MGTableViewCell class])];
    }
    return _tableView;
}

- (MGProfileHeaderView *)headerView{
    
    if (_headerView==nil) {
        _headerView = [[MGProfileHeaderView alloc]init];
    }
    return _headerView;
}

@end
