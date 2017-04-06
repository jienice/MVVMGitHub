//
//  MGExploreCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreCell.h"
#import "MGExploreCollectionViewCell.h"
#import "MGExploreCellViewModel.h"
#import "MGExploreCollectionViewDefaultCell.h"
#import "MGRepositoriesModel.h"

#define MGExploreCell_HEIGHT 250
#define MGExploreCell_TITLE_HEIGHT 44

static NSString *MGExploreCollectionViewCellDefault = @"MGExploreCollectionViewCellDefault";
static NSString *MGExploreCollectionViewCellImageAndDesc = @"MGExploreCollectionViewCellImageAndDesc";

@interface MGExploreCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *seeAllButton;
@property (nonatomic, assign) BOOL canLayout;
@property (nonatomic, strong, readwrite) NSArray *collectionDataSource;
@property (nonatomic, copy, readwrite) NSString *titleString;
@property (nonatomic, strong, readwrite) MGExploreCellViewModel *rowViewModel;
@property (nonatomic, strong, readwrite) RACCommand *seeAllCommand;
@property (nonatomic, strong, readwrite) RACCommand *didSelectedItemCommand;

@end

@implementation MGExploreCell

#pragma mark - Instance Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        @weakify(self);
        [[[[RACObserve(self, collectionDataSource) distinctUntilChanged]
          takeUntil:self.rac_prepareForReuseSignal]
          subscribeOn:[RACScheduler mainThreadScheduler]]subscribeNext:^(id x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}
+ (instancetype)configExploreCell:(UITableView *)tableView
                  reuseIdentifier:(NSString *)reuseIdentifier
                     rowViewModel:(MGExploreCellViewModel *)rowViewModel{
    
    MGExploreCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MGExploreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:cell.titleLabel];
        [cell.contentView addSubview:cell.seeAllButton];
        [cell.contentView addSubview:cell.collectionView];
        cell.canLayout=YES;
    }
    cell.rowViewModel = rowViewModel;
    cell.titleLabel.text = rowViewModel.titleString;
    cell.collectionDataSource = rowViewModel.dataSource;
    return cell;
}
+ (CGFloat)cellHeight{
    
    return MGExploreCell_HEIGHT;
}
- (void)setCanLayout:(BOOL)canLayout{
    
    _canLayout = canLayout;
    if (canLayout) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}
#pragma mark - Life Cycle
- (void)layoutSubviews{
    
    if (self.canLayout) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.seeAllButton.mas_left);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.collectionView.mas_top);
            make.height.mas_equalTo(MGExploreCell_TITLE_HEIGHT);
        }];
        
        [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_top);
            make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
            make.width.mas_equalTo(50);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(self.seeAllButton.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
}
#pragma mark - Load Data

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.rowViewModel.rowType == MGExploreRowForPopularUsers) {
        OCTUser *user=self.rowViewModel.dataSource[indexPath.item];
        MGExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGExploreCollectionViewCellDefault
                                                                                      forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:user.avatarURL placeholderImage:nil];
        return cell;
    }
    MGExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGExploreCollectionViewCellImageAndDesc
                                                                                  forIndexPath:indexPath];
    MGRepositoriesModel *repo=self.rowViewModel.dataSource[indexPath.item];
    [cell.imageView sd_setImageWithURL:repo.owner.avatarURL placeholderImage:nil];
    cell.repoDescLabel.text = repo.repoDescription;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.didSelectedItemCommand execute:RACTuplePack(self.rowViewModel,indexPath)];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(150,
                      MGExploreCell_HEIGHT-MGExploreCell_TITLE_HEIGHT-10);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.f;
}

#pragma mark - Lazy Load
- (UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = MGFont(14);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"标题文字";
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView{
    
    if (_collectionView==nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        [_collectionView registerNib:[UINib nibWithNibName:@"MGExploreCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:MGExploreCollectionViewCellImageAndDesc];
        [_collectionView registerNib:[UINib nibWithNibName:@"MGExploreCollectionViewDefaultCell" bundle:nil]
          forCellWithReuseIdentifier:MGExploreCollectionViewCellDefault];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIButton *)seeAllButton{
    
    if (_seeAllButton == nil) {
        _seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeAllButton setTitle:@"All" forState:UIControlStateNormal];
        [_seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_seeAllButton setTitle:@"All" forState:UIControlStateHighlighted];
        [_seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _seeAllButton.titleLabel.font = MGFont(14);
        _seeAllButton.rac_command = self.seeAllCommand;
    }
    return _seeAllButton;
}
- (RACCommand *)didSelectedItemCommand{
    
    if(_didSelectedItemCommand==nil){
        _didSelectedItemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:input];
        }];
    }
    return _didSelectedItemCommand;
}
- (RACCommand *)seeAllCommand{
    
    if (_seeAllCommand==nil) {
        @weakify(self);
        _seeAllCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal return:@(self.rowViewModel.rowType)];
        }];
    }
    return _seeAllCommand;
}
@end
