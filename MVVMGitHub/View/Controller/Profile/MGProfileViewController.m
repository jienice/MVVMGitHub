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
@property (nonatomic, strong) MGProfileHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

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
    self.headerView.didClickedCategoryCommand = self.viewModel.clickedCategoryCommand;
}

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
    cell.text.textColor = MGBlackColor;
    cell.text.userInteractionEnabled = NO;
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
            if (self.viewModel.user.email.isExist) {
                cell.text.text = self.viewModel.user.email;
                if (![self.viewModel.user.objectID isEqualToString:[SAMKeychain mg_objectID]]) {
                    cell.text.textColor = MGHighlightedColor;
                    cell.text.userInteractionEnabled = YES;
                    @weakify(self);
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                        @strongify(self);
                        //添加收件人,如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为","
                        NSString *emailAdd = [NSString stringWithFormat:@"mailto:http://%@",self.viewModel.user.email];
                        NSURL *emailUrl = [NSURL URLWithString:emailAdd];
                        [[UIApplication sharedApplication] openURL:emailUrl options:@{} completionHandler:nil];
                    }];
                    [cell.text addGestureRecognizer:longPress];
                }
            }else{
                cell.text.text = @"Not Set";
            }
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row == 1){
            
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - About UI
- (void)configUI{
    self.navigationItem.title = self.viewModel.title;
    self.view.backgroundColor = MGWhiteColor;
    if ([self.navigationController.navigationBar isHidden]) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    if (self.navigationController.childViewControllers.count>1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemForPopViewController];
    }
    [self.view addSubview:self.tableView];
    self.headerView.frame = CGRectMake(0, 0, self.tableView.width, 250);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.frame = self.headerView.frame;
}

#pragma mark - Lazy Load
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MGNAV_STATUS_BAR_HEIGHT, MGSCREEN_WIDTH, MGSCREEN_HEIGHT)
                                                 style:UITableViewStyleGrouped];
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
