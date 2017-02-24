//
//  AppDelegate.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGAppDelegate.h"
#import "MGLoginViewModel.h"
#import "MGLoginViewController.h"

@interface MGAppDelegate ()

@property (nonatomic, strong, readwrite) MGViewModelBasedNavigation *viewModelBased;

@end

@implementation MGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configMethodHooks];
    [self configLaunchView];
    [self configHUD];
    [self configKeyBoardManager];
    return YES;
}
- (void)configLaunchView{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *launchVC = [self configLaunchViewController];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:launchVC];
    self.viewModelBased.navigationController = mainNav;
    self.window.rootViewController = self.viewModelBased.navigationController;
    [self.window makeKeyAndVisible];
}

- (UIViewController *)configLaunchViewController{
    
    if ([SAMKeychain mg_accessToken].isExist && [SAMKeychain mg_rawlogin].isExist) {
        OCTUser *user = [OCTUser userWithRawLogin:[SAMKeychain mg_rawlogin] server:OCTServer.dotComServer];
        OCTClient *client = [OCTClient authenticatedClientWithUser:user token:[SAMKeychain mg_accessToken]];
        [self setClient:client];
        MGViewModel *viewModel = [[NSClassFromString(@"MGMainViewModel") alloc]initWithParams:nil];
        return [[NSClassFromString(@"MGMainViewController") alloc]initWithViewModel:viewModel];
    }
    MGViewModel *viewModel = [[NSClassFromString(@"MGLoginViewModel") alloc]initWithParams:nil];
    return [[NSClassFromString(@"MGLoginViewController") alloc]initWithViewModel:viewModel];
}
- (void)configMethodHooks{
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> obj){
        if ([[obj instance] conformsToProtocol:@protocol(MGViewControllerProtocol)] &&
            [[obj instance] respondsToSelector:@selector(bindViewModel)]) {
            [[obj instance] performSelector:@selector(bindViewModel)];
        }
                                   UIViewController *vc = [obj instance];
                                   [vc.view setBackgroundColor:[UIColor whiteColor]];
    }error:nil];
    
    
    [MGViewModel aspect_hookSelector:@selector(initWithParams:)
                         withOptions:AspectPositionAfter
                          usingBlock:^(id<AspectInfo> obj){
        if ([[obj instance] respondsToSelector:@selector(initialize)]) {
            [[obj instance] performSelector:@selector(initialize)];
        }
    }error:nil];
         
}
- (void)configKeyBoardManager{
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}
- (void)configHUD{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - lazy load
- (MGViewModelBasedNavigation*)viewModelBased{
    
    if (_viewModelBased==nil) {
        _viewModelBased = [[MGViewModelBasedNavigation alloc]init];
    }
    return _viewModelBased;
}
@end
