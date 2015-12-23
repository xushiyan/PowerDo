//
//  NSDate+PowerKit.h
//  PowerKit
//
//  Created by XU SHIYAN on 7/12/15.
//  Copyright © 2015 PowerStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PowerKit)

+ (instancetype)dateOfTodayNoon;
+ (instancetype)dateOfTodayNoonFromNowDate:(NSDate *)nowDate;
+ (instancetype)dateOfTodayEnd;
+ (instancetype)dateOfTodayEndFromNowDate:(NSDate *)nowDate;
+ (instancetype)dateOfTomorrowEnd;
+ (instancetype)dateOfTomorrowEndFromNowDate:(NSDate *)nowDate;

@end
