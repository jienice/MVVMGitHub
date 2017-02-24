//
//  MGSegmentView.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSegmentView.h"

@interface MGSegmentView ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@end

@implementation MGSegmentView

- (void)setTitles:(NSArray *)titles{
    
    _titles = titles;
//    self.segmentedControl.numberOfSegments = _titles.count;
}
@end
