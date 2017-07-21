//
//  MGSourceCodeViewController.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/7/21.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGSourceCodeViewController.h"
#import "MGSourceCodeViewModel.h"

@interface MGSourceCodeViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) MGSourceCodeViewModel *viewModel;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@end

@implementation MGSourceCodeViewController


#pragma mark - Instance Method
- (instancetype)initWithViewModel:(id<MGViewModelProtocol>)viewModel{
    if (self = [super init]) {
        self.viewModel = (MGSourceCodeViewModel *)viewModel;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel:nil];
}
- (void)bindViewModel:(id)viewModel{
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"codeview" ofType:@".html"];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:nil];
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    
    @weakify(self);
    [self.bridge registerHandler:@"getInitDataFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        responseCallback(@{ @"title": self.viewModel.title ?: @"",
                            @"UTF8String": self.viewModel.UTF8String ?: @"",
                            @"lineWrapping": @YES });
    }];
    
    [self.bridge callHandler:@"getInitDataFromObjC"];
}
- (void)configUI{
    [self.view addSubview:self.webView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  barButtonItemForPopViewController];
}
#pragma mark - Bind ViewModel

#pragma mark - Touch Action

#pragma mark - Delegate Method
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [self.bridge callHandler:@"getInitDataFromObjC"];
}
#pragma mark - Lazy Load

- (WKWebView *)webView {
	if(_webView == nil) {
		_webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.navigationDelegate = self;
	}
	return _webView;
}

@end
