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
    [self.viewModel.fetchSourceCodeCommand execute:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //clear cache
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}
- (void)configUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.webView];
    self.title = self.viewModel.fileName;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  barButtonItemForPopViewController];
}
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id)viewModel{
    
    @weakify(self);
    [[RACObserve(self, viewModel.UTF8String) ignore:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self.bridge callHandler:@"getInitDataFromObjC" data:@{@"title":self.viewModel.title?:@"",
                                                               @"UTF8String":self.viewModel.UTF8String}];
    }];
    [self.viewModel.fetchSourceCodeCommand.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            [SVProgressHUD show];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
    [self.viewModel.fetchSourceCodeCommand.errors subscribeNext:^(id x) {
        NSLog(@"error====%@",x);
    }];
}
#pragma mark - Touch Action
//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

#pragma mark - Delegate Method

#pragma mark - Lazy Load
- (WKWebView *)webView {
	if(_webView == nil) {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc]init];
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.processPool = [[WKProcessPool alloc]init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.userContentController = [[WKUserContentController alloc] init];
		_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        [_webView loadFileURL:self.viewModel.fileURL allowingReadAccessToURL:self.viewModel.fileURL];
	}
	return _webView;
}

- (WKWebViewJavascriptBridge *)bridge {
	if(_bridge == nil) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
        [WKWebViewJavascriptBridge enableLogging];
	}
	return _bridge;
}

@end
