//
//  MGRepoDetailself.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/20.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepoDetailHeaderView.h"

@interface MGRepoDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *repoOwnerImage;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestUpdateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *repoBranchBtn;
@property (nonatomic, strong) MGRepositoriesModel *repo;

@end

@implementation MGRepoDetailHeaderView

- (instancetype)init{
    MGRepoDetailHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MGRepoDetailHeaderView class])
                                                                 owner:self options:nil] firstObject];
    @weakify(view);
    [[view.repoBranchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(view);
        [view.branchClickedCommand execute:nil];
    }];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(view);
        [view.nameLabelClickedCommand execute:nil];
    }];
    [view.repoNameLabel setUserInteractionEnabled:YES];
    [view.repoNameLabel addGestureRecognizer:nameTap];
    return view;
}
- (void)layoutSubviews{
    //赋值后自动布局，获取布局后的整个View的高度并传值。
    if (self.repo) {
        [self.didEndLayoutCommand execute:nil];
    }
}

- (void)bindViewModel:(id)viewModel{
    [self setRepo:viewModel];
    NSString *repoNameString = [NSString stringWithFormat:@"%@/%@",self.repo.owner.name,self.repo.name];
    self.repoNameLabel.attributedText=[self repoNameTransformer:repoNameString];
    self.repoDescLabel.text = self.repo.repoDescription;
    self.createDateLabel.text = [NSString stringWithFormat:@"Create at :%@",self.repo.createdDate];
    self.latestUpdateDateLabel.text = [NSString stringWithFormat:@"Latest commit on :%@",self.repo.updatedDate];
    [self.repoOwnerImage sd_setImageWithURL:self.repo.owner.avatarURL placeholderImage:nil];
    [self.repoBranchBtn setTitle:self.repo.defaultBranch forState:UIControlStateNormal];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (NSMutableAttributedString *)repoNameTransformer:(NSString *)repoName{
    NSMutableAttributedString *muatt = [[NSMutableAttributedString alloc]initWithString:repoName];
    NSRange sepRang = [repoName rangeOfString:@"/"];
    NSRange ownerNameRange = NSMakeRange(0, sepRang.location);
    NSRange repoNameRange = NSMakeRange(sepRang.location+sepRang.length, repoName.length-(sepRang.location+sepRang.length));
    [muatt addAttributes:@{NSForegroundColorAttributeName:MGHighlightedColor,NSFontAttributeName:MGFont(14)} range:ownerNameRange];
    [muatt addAttributes:@{NSForegroundColorAttributeName:MGHighlightedColor,NSFontAttributeName:MGBlodFont(14)} range:repoNameRange];
    return muatt;
}
#pragma mark - lazy load
- (RACCommand *)didEndLayoutCommand{
    if (_didEndLayoutCommand==nil) {
        @weakify(self);
        _didEndLayoutCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[RACSignal return:@(self.repoBranchBtn.height+self.repoBranchBtn.top)]
                    deliverOn:RACScheduler.mainThreadScheduler];
        }];
    }
    return _didEndLayoutCommand;
}
- (RACCommand *)changeBranchCommand{
    if (_changeBranchCommand==nil) {
        @weakify(self);
        _changeBranchCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
            @strongify(self);
            [self.repoBranchBtn setTitleForAllState:input];
            return [RACSignal empty];
        }];
    }
    return _changeBranchCommand;
}
@end
