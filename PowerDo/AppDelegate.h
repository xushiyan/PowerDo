//
//  AppDelegate.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWDTaskManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PWDTaskManager *taskManager;

@end

