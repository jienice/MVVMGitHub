//
//  MGUserModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/19.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGUserModel : NSObject

@property (nonatomic, strong) NSNumber *ID;//id
@property (nonatomic, copy) NSString *organizations_url;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *received_events_url;
@property (nonatomic, copy) NSString *following_url;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *subscriptions_url;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *repos_url;
@property (nonatomic, copy) NSString *html_url;
@property (nonatomic, copy) NSString *events_url;
@property (nonatomic, strong) NSNumber *site_admin;
@property (nonatomic, copy) NSString *starred_url;
@property (nonatomic, copy) NSString *gists_url;
@property (nonatomic, copy) NSString *gravatar_id;
@property (nonatomic, copy) NSString *followers_url;


@end
