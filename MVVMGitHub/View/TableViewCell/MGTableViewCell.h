//
//  MGTableViewCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/7.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
