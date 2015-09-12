//
//  PWDTask.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTask.h"
#import "PWDConstants.h"
#import "PWDTaskManager.h"

@implementation PWDTask

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        _createDate = now;
        
        NSDate *todayStart = [calendar startOfDayForDate:now];
        NSDate *dueDate = [[calendar dateByAddingUnit:NSCalendarUnitDay value:2 toDate:todayStart options:0] dateByAddingTimeInterval:-1];
        _dueDate = dueDate;
        
    }
    return self;
}

- (instancetype)init {
    return [self initWithTitle:@""];
}

- (void)setTitle:(NSString *)title {
    _title = title ? [title copy]: @"";
}

- (void)setDueDate:(NSDate *)dueDate {
    NSComparisonResult result = [dueDate compare:_createDate];
    if (result != NSOrderedAscending) {
        _dueDate = dueDate;
    }
}

@end
