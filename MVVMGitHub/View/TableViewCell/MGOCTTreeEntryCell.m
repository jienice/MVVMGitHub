//
//  MGOCTTreeEntryCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGOCTTreeEntryCell.h"

@interface MGOCTTreeEntryCell()


@property (weak, nonatomic) IBOutlet UILabel *treeEntryDesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *modeImageView;

@property (nonatomic, strong) UIImage *fileImage;
@property (nonatomic, strong) UIImage *directioryImage;

@end

@implementation MGOCTTreeEntryCell


- (void)awakeFromNib{
    
    [super awakeFromNib];
}

- (void)bindViewModel:(id)viewModel{
//    129.151。176
//    3.102.214
    OCTTreeEntry *treeEntry = viewModel;
    self.treeEntryDesLabel.text = treeEntry.path;
    NSLog(@"%@",treeEntry);
    
    
    switch (treeEntry.mode) {
        case OCTTreeEntryModeFile:{
            self.modeImageView.image = self.fileImage;
        }
            break;
        case OCTTreeEntryModeExecutable:{
            self.modeImageView.image = self.fileImage;
        }
            break;
        case OCTTreeEntryModeSubdirectory:{
            self.modeImageView.image = self.directioryImage;
        }
            break;
        case OCTTreeEntryModeSubmodule:{
            
        }
            break;
        case OCTTreeEntryModeSymlink:{
            
        }
            break;
        default:
            break;
    }
}

- (NSNumber *)cellHeightWithModel:(id)model{
    
    return @35;
}
#pragma mark - lazy load
- (UIImage *)fileImage{
    if (_fileImage==nil) {
       _fileImage = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconFileText]
                                   backgroundColor:MGWhiteColor
                                         iconColor:MGRGBColor(129, 151, 176)
                                         iconScale:1.0
                                           andSize:self.modeImageView.size];
    }
    return _fileImage;
}
- (UIImage *)directioryImage{
    if (_directioryImage==nil) {
        _directioryImage = [UIImage octicon_imageWithIcon:[NSString octicon_iconDescriptionForEnum:OCTIconFileDirectory]
                                          backgroundColor:MGWhiteColor
                                                iconColor:MGRGBColor(129, 151, 176)
                                                iconScale:1.0
                                                  andSize:self.modeImageView.size];
    }
    return _directioryImage;
}
@end
