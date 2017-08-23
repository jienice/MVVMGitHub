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
    view.userBigImageView.image = [[UIImage imageWithColor:MGNormalColor] imageByBlurSoft];
    view.userImageView.image = [UIImage imageWithColor:MGNormalColor];
    return view;
}

- (void)bindViewModel:(id)viewModel{
    _user = viewModel;
    @weakify(self);
    self.userNameLabel.text = _user.name;
    [SDWebImageManager.sharedManager loadImageWithURL:_user.avatarURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        @strongify(self);
        self.userBigImageView.image = [image imageByBlurSoft];
        self.userImageView.image = image;
    }];
    self.publicRepoCountLabel.text = [NSString stringWithFormat:@"%ld", (long) _user.publicRepoCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", (long) _user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", (long) _user.followingCount];

}
- (IBAction)categoryBtnClicked:(UIButton *)sender {
    [self.didClickedCategoryCommand execute:@(sender.tag)];
}

@end
