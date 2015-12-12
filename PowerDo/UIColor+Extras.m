//
//  PWDColor.m
//  PowerDo
//
//  Created by Wang Jin on 17/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "UIColor+Extras.h"

@implementation UIColor (Extras)

+ (UIColor *)themeColor {
    return [UIColor flatNephritisColor];
}

+ (UIColor *)happyMoodColor {
    return [UIColor colorFromHexString:@"e74c3c"];
}

+ (UIColor *)unhappyMoodColor {
    return [UIColor colorFromHexString:@"3498db"];
}

+ (UIColor *)colorFromTaskDifficulty:(PWDTaskDifficulty)difficulty {
    UIColor *color;
    switch (difficulty) {
        case PWDTaskDifficultyEasy:
            color = [UIColor flatSunflowerColor];
            break;
        case PWDTaskDifficultyMedium:
            color = [UIColor flatCarrotColor];
            break;
        case PWDTaskDifficultyHard:
            color = [UIColor flatPomegranateColor];
            break;
    }
    return color;
}

@end
