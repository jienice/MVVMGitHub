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
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *blogLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, assign, readwrite) CGFloat height;

@end


@implementation MGUserDetailHeaderView

- (instancetype)initWithUser:(OCTUser *)user{
    
    if (self = [super init]) {
        [self addSubview:self.iconImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.emailLabel];
        [self addSubview:self.blogLabel];
        [self addSubview:self.companyLabel];
        [self setUser:user];
    }
    return self;
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
        make.height.mas_equalTo(self.emailLabel.mas_height);
        make.top.mas_equalTo(self.iconImage.mas_top);
        make.bottom.mas_equalTo(self.emailLabel.mas_top).offset(-LINE_SPACE);
    }];
    
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
    }];
    
    [self.blogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(LINE_SPACE);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blogLabel.mas_bottom).offset(LINE_SPACE);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LINE_SPACE);
    }];
    
}
- (void)setUser:(OCTUser *)user{
    
    [self.iconImage sd_setImageWithURL:user.avatarURL placeholderImage:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"name:%@",user.name];
    self.emailLabel.text = [NSString stringWithFormat:@"Email:%@",
                            [user.email isExist]?user.email:@"balbalbalblalbalba"];
    self.blogLabel.text = [NSString stringWithFormat:@"Blog:%@",
                           [user.blog isExist]?user.blog:@"balbalbalblalbalba"];
    self.companyLabel.text = [NSString stringWithFormat:@"Company:%@",
                              [user.company isExist]?user.company:@"balbalbalblalbalba"];
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
- (UILabel *)emailLabel{
    
    if (_emailLabel==nil) {
        _emailLabel = [UILabel new];
        [_emailLabel setFont:MGFont(16)];
        [_emailLabel setTextColor:[UIColor blackColor]];
        [_emailLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _emailLabel;
}
- (UILabel *)blogLabel{
    
    if (_blogLabel==nil) {
        _blogLabel = [UILabel new];
        [_blogLabel setFont:MGFont(16)];
        [_blogLabel setTextColor:[UIColor blackColor]];
        [_blogLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _blogLabel;
}
- (UILabel *)companyLabel{
    
    if (_companyLabel==nil) {
        _companyLabel = [UILabel new];
        [_companyLabel setFont:MGFont(16)];
        [_companyLabel setTextColor:[UIColor blackColor]];
        [_companyLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _companyLabel;
}
@end
