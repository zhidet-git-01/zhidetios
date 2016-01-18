//
//  AppDelegate.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "AppDelegate.h"
#import "LeadViewController.h"
#import "AFNetworking.h"
#import "BasicTabBarController.h"
#import <netinet/in.h>
#import <UMSocial.h>
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>



@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    
    // 判断是否第一次打开
//    
//    BOOL mark = [userDefault boolForKey:@"isFirst"];
//    
//    if (mark == NO) {
//        
//        self.window.rootViewController = [[LeadViewController alloc] init];
//        [userDefault setBool:YES forKey:@"isFirst"];
//        
//    } else
//    {
//        BasicTabBarController *tabBarVc = [[BasicTabBarController alloc] init];
//        self.window.rootViewController = tabBarVc;
//
//    }
    
    
    [UMSocialData setAppKey:@"568b9a68e0f55a45bb0009d2"];
    
    [UMSocialQQHandler setQQWithAppId:@"1105016327" appKey:@"m1q4AOB8wLJka3VT" url:@"http://www.zhidet.com"];
    
    [UMSocialWechatHandler setWXAppId:@"wx739a1a87ec718c4a" appSecret:@"e62b5ba88748e64bdf0b9c14e7d8c253" url:@"http://www.zhidet.com"];
    
    
    BasicTabBarController *tabBarVc = [[BasicTabBarController alloc] init];
    self.window.rootViewController = tabBarVc;
    //判断是否连接网络
    [self monitorNetStatus];
    
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark ------网络状态
- (void) monitorNetStatus{
    
    if (![self connectedToNetwork]) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络未连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alterView show];
    }
}
#pragma mark - 判断是否有网络
-(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

//去设置事件（代理方法）
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
