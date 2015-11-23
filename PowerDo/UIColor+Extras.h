//
//  PWDColor.h
//  PowerDo
//
//  Created by Wang Jin on 17/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDTask.h"

@interface UIColor (Extras)

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)themeColor;
+ (UIColor *)happyMoodColor;
+ (UIColor *)unhappyMoodColor;
+ (UIColor *)colorFromTaskDifficulty:(PWDTaskDifficulty)difficulty;
+ (UIColor *)flatOrangeColor;
+ (UIColor *)flatSunflowerColor;
+ (UIColor *)flatCarrotColor;

@end
