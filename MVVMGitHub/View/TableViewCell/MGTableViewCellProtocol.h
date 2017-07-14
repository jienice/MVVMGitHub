//
//  MGTableViewCellProtocol.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/12.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGTableViewCellProtocol <NSObject,MGReactiveViewProtocol>


@optional
- (NSNumber *)cellHeightWithModel:(id)model;



@end
