//
//  MGUserDetailHeaderView.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGUserDetailHeaderView.h"


#define LINE_SPACE 5

@interface MGUserDetailHeaderView()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *emailButton;
@property (nonatomic, strong) UIButton *blogButton;
@property (nonatomic, strong) UIButton *companyButton;
@property (nonatomic, assign, readwrite) CGFloat height;

@end


@implementation MGUserDetailHeaderView

+ (instancetype)configUserDetailHeaderWithUser:(OCTUser *)user{
    
    MGUserDetailHeaderView *view = [[MGUserDetailHeaderView alloc]init];
    [view addSubview:view.iconImage];
    [view addSubview:view.nameLabel];
    [view addSubview:view.emailButton];
    [view addSubview:view.blogButton];
    [view addSubview:view.companyButton];
    [view setUser:user];
    return view;
}

- (void)layoutSubviews{
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LINE_SPACE);
        make.top.mas_equalTo(self.mas_top).offset(LINE_SPACE);
        make.size.mas_equalTo(CGSizeMake(60,60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(LINE_SPACE);
        make.right.mas_equalTo(self.mas_right).offset(-LINE_SPACE);
        make.height.mas_equalTo(self.emailButton.mas_height);
        make.top.mas_equalTo(self.iconImage.mas_top);
        make.bottom.mas_equalTo(self.emailButton.mas_top).offset(-LINE_SPACE);
    }];
    
    [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
    }];
    
    [self.blogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(LINE_SPACE);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
    }];
    
    [self.companyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blogButton.mas_bottom).offset(LINE_SPACE);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LINE_SPACE);
    }];
}
- (void)setUser:(OCTUser *)user{
    
    [self.iconImage sd_setImageWithURL:user.avatarURL placeholderImage:nil];
    self.nameLabel.text = user.name;
    [self.emailButton setTitle:[NSString stringWithFormat:@"Email:%@",
                                [user.email isExist]?user.email:@""]
                      forState:UIControlStateNormal];
    
    [self.blogButton setTitle:[NSString stringWithFormat:@"Blog:%@",
                               [user.blog isExist]?user.blog:@""]
                     forState:UIControlStateNormal];
    
    [self.companyButton setTitle:[NSString stringWithFormat:@"Company:%@",
                                  [user.company isExist]?user.company:@""]
                        forState:UIControlStateNormal];
}
- (CGFloat)height{
    
    return LINE_SPACE + 60 + LINE_SPACE + 40 + LINE_SPACE + 40 + LINE_SPACE;
}
#pragma mark - lazy load
- (UIImageView *)iconImage{
    
    if (_iconImage==nil) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}
- (UILabel *)nameLabel{
    
    if (_nameLabel==nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
- (UIButton *)emailButton{
    
    if (_emailButton==nil) {
        _emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emailButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
    }
    return _emailButton;
}
- (UIButton *)blogButton{
    
    if (_blogButton==nil) {
        _blogButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_blogButton setTitleColor:[UIColor blackColor]
                          forState:UIControlStateNormal];
    }
    return _blogButton;
}
- (UIButton *)companyButton{
    
    if (_companyButton==nil) {
        _companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_companyButton setTitleColor:[UIColor blackColor]
                             forState:UIControlStateNormal];
    }
    return _companyButton;
}
@end
