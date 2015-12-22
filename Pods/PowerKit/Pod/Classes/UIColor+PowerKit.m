//
//  UIColor+PowerKit.m
//  PowerKit
//
//  Created by XU SHIYAN on 12/12/15.
//  Copyright © 2015 PowerStudio. All rights reserved.
//

#import "UIColor+PowerKit.h"

@implementation UIColor (PowerKit)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - http://flatuicolors.com
+ (UIColor *)flatTurquoiseColor {
    return [UIColor colorFromHexString:@"1abc9c"];
}
+ (UIColor *)flatGreenSeaColor {
    return [UIColor colorFromHexString:@"16a085"];
}
+ (UIColor *)flatSunflowerColor {
    return [UIColor colorFromHexString:@"f1c40f"];
}
+ (UIColor *)flatOrangeColor {
    return [UIColor colorFromHexString:@"f39c12"];
}
+ (UIColor *)flatEmeraldColor {
    return [UIColor colorFromHexString:@"2ecc71"];
}
+ (UIColor *)flatNephritisColor {
    return [UIColor colorFromHexString:@"27ae60"];
}
+ (UIColor *)flatCarrotColor {
    return [UIColor colorFromHexString:@"e67e22"];
}
+ (UIColor *)flatPumpkinColor {
    return [UIColor colorFromHexString:@"d35400"];
}
+ (UIColor *)flatPeterRiverColor {
    return [UIColor colorFromHexString:@"3498db"];
}
+ (UIColor *)flatBelizeHoleColor {
    return [UIColor colorFromHexString:@"2980b9"];
}
+ (UIColor *)flatAlizarinColor {
    return [UIColor colorFromHexString:@"e74c3c"];
}
+ (UIColor *)flatPomegranateColor {
    return [UIColor colorFromHexString:@"c0392b"];
}
+ (UIColor *)flatAmethystColor {
    return [UIColor colorFromHexString:@"9b59b6"];
}
+ (UIColor *)flatWisteriaColor {
    return [UIColor colorFromHexString:@"8e44ad"];
}
+ (UIColor *)flatCloudsColor {
    return [UIColor colorFromHexString:@"ecf0f1"];
}
+ (UIColor *)flatSilverColor {
    return [UIColor colorFromHexString:@"bdc3c7"];
}
+ (UIColor *)flatWetAsphaltColor {
    return [UIColor colorFromHexString:@"34495e"];
}
+ (UIColor *)flatMidnightBlueColor {
    return [UIColor colorFromHexString:@"2c3e50"];
}
+ (UIColor *)flatConcreteColor {
    return [UIColor colorFromHexString:@"95a5a6"];
}
+ (UIColor *)flatAsbestosColor {
    return [UIColor colorFromHexString:@"7f8c8d"];
}
@end
