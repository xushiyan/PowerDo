//
//  NSDate+PowerKit.m
//  PowerKit
//
//  Created by XU SHIYAN on 7/12/15.
//  Copyright © 2015 PowerStudio. All rights reserved.
//

#import "NSDate+PowerKit.h"

@implementation NSDate (PowerKit)

+ (instancetype)dateOfTodayNoon {
    return [self dateOfTodayNoonFromNowDate:[NSDate date]];
}

+ (instancetype)dateOfTodayNoonFromNowDate:(NSDate *)nowDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateBySettingHour:12 minute:0 second:0 ofDate:nowDate options:0];
}

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
