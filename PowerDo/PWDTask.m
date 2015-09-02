//
//  PWDTask.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTask.h"

@implementation PWDTask

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
        NSDate *todayStart = [calendar dateFromComponents:components];
        NSDate *todayEnd = [[calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:todayStart options:0] dateByAddingTimeInterval:-1];
        _createDate = now;
        _dueDate = todayEnd;
        
    }
    return self;
}

- (instancetype)init {
    return [self initWithTitle:@""];
}

-(void)setTitle:(NSString *)title {
    _title = title ? [title copy]: @"";
}

@end
