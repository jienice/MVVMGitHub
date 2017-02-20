//
//  WKWebView+MGWeb.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/17.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "WKWebView+MGWeb.h"

@implementation WKWebView (MGWeb)

#pragma mark - 公开方法
- (void)autoSetHeightAfterLoaded:(void(^)(CGFloat height))complete{
    
    @weakify(self);
    WKWebViewJavascriptBridge* bridge=[WKWebViewJavascriptBridge bridgeForWebView:self];
    [bridge registerHandler:@"(function(){"
     "var allLinks = document.getElementsByTagName('a');"
     "if (allLinks) {"
     "for (var i=0; i<allLinks.length; i++) {"
     "var link = allLinks[i];"
     "var target = link.getAttribute('target');"
     "if (target && target == '_blank') {"
     "link.setAttribute('target','_self');"
     "}"
     "}"
     "}"
     "})();" handler:nil];
    
    [bridge registerHandler:@"Math.max(document.body.scrollHeight, document.body.offsetHeight,document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);" handler:^(NSString *result, WVJBResponseCallback responseCallback) {
        @strongify(self);
        CGFloat height = result?result.floatValue:self.scrollView.contentSize.height;
        NSLog(@"webView.contentHeight====%f",height);
        if (complete) {
            complete(height);
        }
    }];
}
@end
