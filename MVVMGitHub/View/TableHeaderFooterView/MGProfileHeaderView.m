//
//  MGProfileHeaderView.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/6.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGProfileHeaderView.h"
#import "MGUser.h"

@interface MGProfileHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userBigImageView;
@property (weak, nonatomic) IBOutlet UILabel *publicRepoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *repoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *followerimageView;


@property (weak, nonatomic) IBOutlet UIView *repoShowView;
@property (weak, nonatomic) IBOutlet UIView *followerShowView;
@property (weak, nonatomic) IBOutlet UIView *followingShowView;

@end


@implementation MGProfileHeaderView{
    MGUser *_user;
}


- (instancetype)init{
    
    MGProfileHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MGProfileHeaderView class]) owner:self options:nil]
                                    firstObject];
    
    view.didClickedCategoryCommand = [[RACCommand alloc]initWithEnabled:[[view rac_signalForSelector:@selector(bindViewModel:)] map:^id(id value) {
        return @YES;
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
    return view;
}

- (void)bindViewModel:(id)viewModel{
    
    _user = viewModel;
    @weakify(self);
    self.userNameLabel.text = _user.name;
    [self.userImageView sd_setImageWithURL:_user.avatarURL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        self.userBigImageView.image = [image imageByBlurSoft];
    }];
    self.publicRepoCountLabel.text = [NSString stringWithFormat:@"%ld",_user.publicRepoCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld",_user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld",_user.followingCount];

    self.repoImageView.image = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconRepo]
                                              backgroundColor:MGWhiteColor
                                                    iconColor:MGBlackColor
                                                    iconScale:1.0 andSize:CGSizeMake(20, 20)];
}
- (IBAction)categoryBtnClicked:(UIButton *)sender {
    
    [self.didClickedCategoryCommand execute:@(sender.tag)];
}

@end
