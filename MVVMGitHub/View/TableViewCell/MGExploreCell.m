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

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *seeAllButton;
@property (nonatomic, assign) BOOL canLayout;
@property (nonatomic, strong, readwrite) NSArray *collectionDataSource;
@property (nonatomic, copy, readwrite) NSString *titleString;
@property (nonatomic, strong, readwrite) MGExploreCellViewModel *rowViewModel;
@property (nonatomic, strong, readwrite) RACCommand *seeAllCommand;
@property (nonatomic, strong, readwrite) RACCommand *didSelectedItemCommand;

@end

@implementation MGExploreCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MGExploreCollectionViewCell class])
                                                    bundle:nil]
          forCellWithReuseIdentifier:MGExploreCollectionViewCellImageAndDesc];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MGExploreCollectionViewDefaultCell class])
                                                    bundle:nil]
          forCellWithReuseIdentifier:MGExploreCollectionViewCellDefault];
    
    self.seeAllButton.rac_command = self.seeAllCommand;
}

- (void)bindViewModel:(id)viewModel{
    
    MGExploreCellViewModel *rowViewModel = viewModel;
    self.rowViewModel = rowViewModel;
    self.titleLabel.text = rowViewModel.titleString;
    self.collectionDataSource = rowViewModel.dataSource;
}
+ (CGFloat)cellHeight{
    
    return MGExploreCell_HEIGHT;
}

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
