//
//  AppDelegate.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "AppDelegate.h"
#import "PWDTaskManager.h"
#import "PWDRootViewController.h"
#import "PWDConstants.h"
#import "UIColor+Extras.h"
#import "PWDDailyRecord.h"
@import PowerKit;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) insertDailyRecordsIfNecessary {
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    
    PWDDailyRecord *latest = [taskManager fetchLatestRecord];
    if (latest) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *latestDate = [NSDate dateWithTimeIntervalSince1970:latest.dateRaw];
        
        // ignore if latestDate is some date in the future, meaning user time travelled to the past
        
        if ([latestDate timeIntervalSinceDate:[calendar startOfDayForDate:[NSDate date]]] < 0) {
            // if latestDate is some date in the past
            
            if (![calendar isDateInToday:latestDate]) {
                // if latest record not in today
                [[NSNotificationCenter defaultCenter] postNotificationName:PWDDayChangeNotification object:[UIApplication sharedApplication]];
                
                // fill up empty records
                // move 1 day forward from latest date
                latestDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:latestDate options:0];
                while (![calendar isDateInToday:latestDate]) {
                    [taskManager insertNewDailyRecordWithTasks:nil date:latestDate inContext:taskManager.managedObjectContext];
                    
                    latestDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:latestDate options:0];
                }
            }
            
        }
    } else {
        // if no record exists, insert new one for today with no tasks
        [taskManager insertNewDailyRecordWithTasks:nil inContext:taskManager.managedObjectContext];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.taskManager = [PWDTaskManager sharedManager];
    
    [self insertDailyRecordsIfNecessary];
    
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWindow.rootViewController = [[PWDRootViewController alloc] init];
    mainWindow.tintColor = [UIColor themeColor];
    self.window = mainWindow;
    [mainWindow makeKeyAndVisible];
    
    return YES;
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    // this will be triggered when day changes and app is in foreground
    [self insertDailyRecordsIfNecessary];
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
