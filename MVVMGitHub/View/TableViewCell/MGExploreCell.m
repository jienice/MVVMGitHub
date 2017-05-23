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
@property (nonatomic, weak) IBOutlet UIButton *seeAllButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collection;

@property (nonatomic, strong, readwrite) MGExploreCellViewModel *rowViewModel;
@property (nonatomic, strong, readwrite) RACCommand *seeAllCommand;
@property (nonatomic, strong, readwrite) RACCommand *didSelectedItemCommand;
@property (nonatomic, strong, readwrite) NSArray *collectionDataSource;


@end

@implementation MGExploreCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self.collection registerNib:[UINib nibWithNibName:NSStringFromClass([MGExploreCollectionViewCell class])
                                                bundle:nil]
          forCellWithReuseIdentifier:MGExploreCollectionViewCellImageAndDesc];
    [self.collection registerNib:[UINib nibWithNibName:NSStringFromClass([MGExploreCollectionViewDefaultCell class])
                                                bundle:nil]
          forCellWithReuseIdentifier:MGExploreCollectionViewCellDefault];

    self.seeAllButton.rac_command = self.seeAllCommand;
}

- (void)bindViewModel:(id)viewModel{
    
    self.rowViewModel = viewModel;
    self.titleLabel.text = self.rowViewModel.titleString;
    self.collectionDataSource = self.rowViewModel.dataSource;
    
    [[self.seeAllCommand.executionSignals.switchToLatest
      takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *rowType) {
        NSLog(@"查看全部%@",rowType);
    }];

//   [[self.didSelectedItemCommand.executionSignals.switchToLatest
//        takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(RACTuple *tucple) {
//        MGExploreCellViewModel *rowViewModel = [tucple first];
//        NSIndexPath *indexPath = [tucple last];
//        NSLog(@"选中%@",indexPath);
////        if (rowViewModel.rowType == MGExploreRowForPopularUsers) {
////            OCTUser *user=rowViewModel.dataSource[indexPath.item];
////            MGUserDetailViewModel *userDetailViewModel = [[MGUserDetailViewModel alloc]
////                                                         initWithParams:@{kNavigationTitle:user.name,
////                                                                          kUserDetailViewModelParamsKeyForUser:user}];
////            [MGSharedDelegate.viewModelBased pushViewModel:userDetailViewModel animated:YES];
////       }else{
////            MGRepositoriesModel *repo=rowViewModel.dataSource[indexPath.item];
////            MGRepoDetailViewModel *repoDetail = [[MGRepoDetailViewModel alloc]
////                                                initWithParams:@{kRepoDetailParamsKeyForRepoOwner:repo.owner.login,
////                                                                 kRepoDetailParamsKeyForRepoName:repo.name}];
////            [MGSharedDelegate.viewModelBased pushViewModel:repoDetail animated:YES];
////       }
//   }];
}
+ (CGFloat)cellHeight{
    
    return MGExploreCell_HEIGHT;
}

#pragma mark - Delegate Method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return 0;
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
