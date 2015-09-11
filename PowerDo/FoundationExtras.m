//
//  FoundationExtras.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "FoundationExtras.h"


@implementation NSDate (Extras)

+ (instancetype) dateFromHour:(NSInteger)hour minute:(NSInteger)minute {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hour;
    components.minute = minute;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

@end