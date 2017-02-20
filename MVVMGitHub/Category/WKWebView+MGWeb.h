//
//  WKWebView+MGWeb.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (MGWeb)

- (void)autoSetHeightAfterLoaded:(void(^)(CGFloat height))complete;


@end
