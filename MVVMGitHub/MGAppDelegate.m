//
//  AppDelegate.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGAppDelegate.h"
#import "MGMainViewController.h"
#import "MGViewController.h"
#import "MGLoginViewController.h"
#import "MGLoginViewModel.h"
#import "MGViewModel.h"

@interface MGAppDelegate ()

@end

@implementation MGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configOCTClient];
    [self configMethodHooks];
    [self configWindow];
    return YES;
}
- (void)configWindow{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MGLoginViewModel *logViewModel = [[MGLoginViewModel alloc]init];
    self.window.rootViewController = [[MGLoginViewController alloc]initWithViewModel:logViewModel];
    /*
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[MGMainViewController alloc]init]];
     */
    [self.window makeKeyAndVisible];
}

- (void)configOCTClient{
    
    [OCTClient setClientID:MG_Client_ID clientSecret:MG_Client_Secret];
}
- (void)configMethodHooks{
    
    [MGViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> obj){
        if ([[obj instance] conformsToProtocol:@protocol(MGViewControllerProtocol)] &&
            [[obj instance] respondsToSelector:@selector(bindViewModel)]) {
            [[obj instance] performSelector:@selector(bindViewModel)];
        }
    }error:nil];
    
    [MGViewModel aspect_hookSelector:@selector(init)
                         withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> obj){
        if ([[obj instance] conformsToProtocol:@protocol(MGViewModelProtocol)] &&
            [[obj instance] respondsToSelector:@selector(initialize)]) {
            [[obj instance] performSelector:@selector(initialize)];
        }
    }error:nil];
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


@end
