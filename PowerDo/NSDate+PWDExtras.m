//
//  NSDate+PWDExtras.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/16/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "NSDate+PWDExtras.h"

@implementation NSDate (PWDExtras)

+ (instancetype)dateOfTodayEnd {
    return [self dateOfTodayEndFromNowDate:[NSDate date]];
}

+ (instancetype)dateOfTodayEndFromNowDate:(NSDate *)nowDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *todayStart = [calendar startOfDayForDate:nowDate];
    NSDate *todayEnd = [[calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:todayStart options:0] dateByAddingTimeInterval:-1];
    return todayEnd;
}

+ (instancetype)dateOfTomorrowEnd {
    return [self dateOfTomorrowEndFromNowDate:[NSDate date]];
}

+ (instancetype)dateOfTomorrowEndFromNowDate:(NSDate *)nowDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *todayStart = [calendar startOfDayForDate:nowDate];
    NSDate *tomorrowEnd = [[calendar dateByAddingUnit:NSCalendarUnitDay value:2 toDate:todayStart options:0] dateByAddingTimeInterval:-1];
    return tomorrowEnd;
}


@end