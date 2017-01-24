//
//  MGExploreCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/28.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGExploreCell.h"
#import "MGExploreCollectionViewCell.h"
#import "MGExploreRowViewModel.h"
#import "MGExploreCollectionViewDefaultCell.h"
#import "MGUserModel.h"
#import "MGRepositoriesModel.h"
#import "MGRepositoriesModel+OCTRepos.h"
#import "MGRepoDetailViewModel.h"


#define MGExploreCell_HEIGHT 250
#define MGExploreCell_TITLE_HEIGHT 45

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

@property (nonatomic, strong) MGExploreRowViewModel *rowViewModel;


@end

@implementation MGExploreCell

#pragma mark - Instance Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        @weakify(self);
        [[[RACObserve(self, collectionDataSource) distinctUntilChanged]
          takeUntil:self.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}
+ (instancetype)configExploreCell:(UITableView *)tableView
                  reuseIdentifier:(NSString *)reuseIdentifier
                     rowViewModel:(MGExploreRowViewModel *)rowViewModel{
    
    MGExploreCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MGExploreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
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
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [self.titleLabel autoSetDimension:ALDimensionHeight toSize:MGExploreCell_TITLE_HEIGHT];
        [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.collectionView];
        [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.seeAllButton autoSetDimension:ALDimensionWidth toSize:50];
        [self.seeAllButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLabel];
        [self.seeAllButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.titleLabel];
        [self.seeAllButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.titleLabel];
        [self.seeAllButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
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
        MGUserModel *user=self.rowViewModel.dataSource[indexPath.item];
        MGExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGExploreCollectionViewCellDefault
                                                                                      forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholderImage:nil];
        return cell;
    }
    MGExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGExploreCollectionViewCellImageAndDesc
                                                                                  forIndexPath:indexPath];
    MGRepositoriesModel *repo=self.rowViewModel.dataSource[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:repo.owner.avatar_url] placeholderImage:nil];
    cell.repoDescLabel.text = repo.des;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.rowViewModel.rowType == MGExploreRowForPopularUsers) {
        MGUserModel *user=self.rowViewModel.dataSource[indexPath.item];
        NSLog(@"%@",user);
    }else{
        MGRepositoriesModel *repo=self.rowViewModel.dataSource[indexPath.item];
        MGRepoDetailViewModel *repoDetailViewModel = [[MGRepoDetailViewModel alloc]initWithRepo:repo];
        
        [[MGSharedDelegate.client fetchRepositoryReadme:[repo transToOCTRepository]] subscribeNext:^(OCTFileContent *x) {
            NSLog(@"%@",x);
        }];
        NSLog(@"%@",repo);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(150,
                      MGExploreCell_HEIGHT-MGExploreCell_TITLE_HEIGHT-5);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
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
        @weakify(self);
        [[_seeAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.seeAllCommand execute:nil];
        }];
    }
    return _seeAllButton;
}
@end
