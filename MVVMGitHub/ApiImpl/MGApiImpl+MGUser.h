//
//  MGApiImpl+MGUser.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/4/14.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGApiImpl.h"

@interface MGApiImpl (MGUser)


- (RACSignal *)fetchUserInfoWithLoginName:(NSString *)loginName;


- (RACSignal *)fetchUserFollowersListWithLoginName:(NSString *)loginName page:(NSInteger)page;


- (RACSignal *)fetchUserFollowingListWithLoginName:(NSString *)loginName page:(NSInteger)page;





@end
