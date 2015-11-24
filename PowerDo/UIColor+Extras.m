//
//  PWDColor.m
//  PowerDo
//
//  Created by Wang Jin on 17/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "UIColor+Extras.h"

@implementation UIColor (Extras)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)themeColor {
    return [UIColor colorFromHexString:@"27ae60"];
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

+ (UIColor *)flatNephritisColor {
    return [UIColor colorFromHexString:@"27ae60"];
}

+ (UIColor *)flatOrangeColor {
    return [UIColor colorFromHexString:@"f39c12"];
}

+ (UIColor *)flatSunflowerColor {
    return [UIColor colorFromHexString:@"f1c40f"];
}

+ (UIColor *)flatCarrotColor {
    return [UIColor colorFromHexString:@"e67e22"];
}

+ (UIColor *)flatPumpkinColor {
    return [UIColor colorFromHexString:@"d35400"];
}

+ (UIColor *)flatPomegranateColor {
    return [UIColor colorFromHexString:@"c0392b"];
}

+ (UIColor *)flatGreenSeaColor {
    return [UIColor colorFromHexString:@"16a085"];
}

@end
