//
//  PWDDailyRecord.m
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDDailyRecord.h"
#import "PWDTask.h"
@import PowerKit;

@implementation PWDDailyRecord

- (void)awakeFromInsert {
    NSDate *now = [NSDate date];
    self.createDateRaw = [now timeIntervalSince1970];
    self.date = [NSDate dateOfTodayNoonFromNowDate:now];
    self.power = 0;
    self.powerUnits = 0;
}

-(void)setDate:(NSDate *)date {
    self.dateRaw = [date timeIntervalSince1970];
}

- (NSDate *)date {
    return [NSDate dateWithTimeIntervalSince1970:self.dateRaw];
}

- (void)updatePowerAndPowerUnits {
    NSSet *tasks = self.tasks;
    float oldPowerUnits = self.powerUnits;
    __block float newPowerUnits = .0f;
    [tasks enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, BOOL * _Nonnull stop) {
        newPowerUnits += task.difficulty;
    }];
    
    if (newPowerUnits > 0) {
        newPowerUnits = 100/newPowerUnits;
        if (oldPowerUnits > 0) {
            float multiple = self.power / oldPowerUnits;
            self.power = newPowerUnits * multiple;
        } else {
            self.power = .0f;
        }
    } else {
        self.power = .0f;
    }
    self.powerUnits = newPowerUnits;
}

- (void)resetPowerAndPowerUnits {
    self.power = 0;
    self.powerUnits = 0;
}

- (void)updatePower {
    NSSet *tasks = self.tasks;
    __block float newPower = .0f;
    float const powerUnits = self.powerUnits;
    [tasks enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, BOOL * _Nonnull stop) {
        if (task.status == PWDTaskStatusCompleted) {
            newPower += task.difficulty * powerUnits;
        }
    }];
    newPower = MIN(100, newPower);
    self.power = newPower;
}

- (NSString *)powerText {
    return [NSString stringWithFormat:@"%.0f", self.power];
}

- (NSString *)dateTextForChart {
    return [self.chartDateFormatter stringFromDate:self.date];
}

@synthesize highlighted = _highlighted;
@synthesize chartDateFormatter = _chartDateFormatter;
- (NSDateFormatter *)chartDateFormatter {
    if (!_chartDateFormatter) {
        _chartDateFormatter = [[NSDateFormatter alloc] init];
        _chartDateFormatter.dateFormat = @"dd\nMMM";
    }
    return _chartDateFormatter;
}
@end
