//
//  AppDelegate.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "AppDelegate.h"
#import "PWDTaskManager.h"
#import "PWDPlanViewController.h"
#import "PWDTodayViewController.h"
#import "PWDStatsViewController.h"
#import "PWDSettingsViewController.h"
#import "PWDConstants.h"
#import "UIColor+Extras.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.taskManager = [PWDTaskManager sharedManager];
    
    PWDPlanViewController *plan_vc = [[PWDPlanViewController alloc] initWithStyle:UITableViewStyleGrouped];
    plan_vc.title = NSLocalizedString(@"Plan", @"Plan tab title");
    plan_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:plan_vc.title image:[UIImage imageNamed:@"ic_assignment"] tag:0];
    UINavigationController *plan_nc = [[UINavigationController alloc] initWithRootViewController:plan_vc];
    
    PWDTodayViewController *today_vc = [[PWDTodayViewController alloc] initWithStyle:UITableViewStylePlain];
    today_vc.title = NSLocalizedString(@"Today", @"Today tab title");
    today_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:today_vc.title image:[UIImage imageNamed:@"ic_today"] tag:1];
    UINavigationController *today_nc = [[UINavigationController alloc] initWithRootViewController:today_vc];
    
    PWDStatsViewController *stats_vc = [[PWDStatsViewController alloc] init];
    stats_vc.title = NSLocalizedString(@"Stats", @"Stats tab title");
    stats_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:stats_vc.title image:[UIImage imageNamed:@"ic_insert_chart"] tag:2];
    UINavigationController *stats_nc = [[UINavigationController alloc] initWithRootViewController:stats_vc];
    
    PWDSettingsViewController *settings_vc = [[PWDSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settings_vc.title = NSLocalizedString(@"Settings", @"Settings tab title");
    settings_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:settings_vc.title image:[UIImage imageNamed:@"ic_settings"] tag:3];
    UINavigationController *settings_nc = [[UINavigationController alloc] initWithRootViewController:settings_vc];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[plan_nc,today_nc,stats_nc,settings_nc];
    
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWindow.rootViewController = tabBarController;
    mainWindow.backgroundColor = [UIColor whiteColor];
    mainWindow.tintColor = [UIColor themeColor];
    self.window = mainWindow;
    [mainWindow makeKeyAndVisible];
    
    return YES;
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
