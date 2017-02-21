//
//  MGWebCell.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGWebCell.h"
#import "WKWebView+MGWeb.h"

@interface MGWebCell ()

@property (nonatomic, strong, readwrite) WKWebView *webView;

@end

@implementation MGWebCell

+ (instancetype)configWebViewCellWithhtml:(NSString *)htmlString{
    
    MGWebCell *cell = [[MGWebCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Web"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:cell.webView];
    cell.webView.frame = cell.contentView.frame;
    [cell.webView loadHTMLString:htmlString baseURL:nil];
    return cell;
}

#pragma mark -lazy load
- (WKWebView *)webView{
    
    if(_webView==nil){
        _webView = [[WKWebView alloc]init];
    }
    return _webView;
}
@end
