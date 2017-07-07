//
//  MGExploreTableViewCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/5/25.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGExploreTableViewCell.h"
#import "MGExploreCollectionViewCell.h"
#import "MGRepositoriesModel.h"
#import "MGRepoDetailViewModel.h"
#import "MGProfileViewModel.h"

@interface MGExploreTableViewCell ()
<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MGExploreTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MGExploreCollectionViewCell class])
                                                    bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([MGExploreCollectionViewCell class])];
}

- (void)bindViewModel:(id)viewModel{
    
    self.cellViewModel = viewModel;
    self.titleLabel.text = self.cellViewModel.cellTitle;
}


#pragma mark - UICollectionViewDelegate\UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return self.cellViewModel.cellData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MGExploreCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MGExploreCollectionViewCell class]) forIndexPath:indexPath];
    switch (self.cellViewModel.cellType) {
        case MGExploreCellTypeOfRepo:{
            MGRepositoriesModel *repo = self.cellViewModel.cellData[indexPath.item];
            [cell bindViewModel:repo];
        }
            break;
        case MGExploreCellTypeOfUser:{
            OCTUser *user = self.cellViewModel.cellData[indexPath.item];
            [cell bindViewModel:user];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.cellViewModel.cellType) {
        case MGExploreCellTypeOfRepo:{
            MGRepositoriesModel *repo = self.cellViewModel.cellData[indexPath.item];
            MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]
                                                 initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.ownerLogin,
                                                                  kRepoDetailParamsKeyForRepoName:repo.name}];
            [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
        }
            break;
        case MGExploreCellTypeOfUser:{
            OCTUser *user = self.cellViewModel.cellData[indexPath.row];
            MGProfileViewModel *profile = [[MGProfileViewModel alloc]
                                           initWithParams:@{kProfileOfUserLoginName:user.login}];
            [MGSharedDelegate.viewModelBased pushViewModel:profile animated:YES];
        }
            
            break;
        default:
            break;
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MGExploreCollectionViewCell itemSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 2, 0, 2);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
@end
