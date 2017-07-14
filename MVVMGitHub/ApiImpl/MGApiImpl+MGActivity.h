//
//  MGApiImpl+MGActivity.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/10.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

@interface MGApiImpl (MGActivity)


- (RACSignal *)fetchUserPublicEventsWithLoginName:(NSString *)loginName;


@end
