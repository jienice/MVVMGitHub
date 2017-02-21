//
//  MGWebCell.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/2/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGWebCell : UITableViewCell

@property (nonatomic, strong, readonly) WKWebView *webView;

+ (instancetype)configWebViewCellWithhtml:(NSString *)htmlString;


@end
