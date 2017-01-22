//
//  MGUserModel+OCTUser.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGUserModel.h"


@class OCTUser;
@interface MGUserModel (OCTUser)


- (OCTUser *)transToOCTUser;


@end
