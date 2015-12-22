//
//  PWDColor.h
//  PowerDo
//
//  Created by Wang Jin on 17/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

@import UIKit;
@import PowerKit;
#import "PWDTask.h"

@interface UIColor (Extras)

+ (UIColor *)themeColor;
+ (UIColor *)happyMoodColor;
+ (UIColor *)unhappyMoodColor;
+ (UIColor *)colorFromTaskDifficulty:(PWDTaskDifficulty)difficulty;


@end
