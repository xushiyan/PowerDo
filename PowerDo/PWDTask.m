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
#import "NSDate+PWDExtras.h"

@implementation PWDTask

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        _createDate = [NSDate date];
        _dueDate = [NSDate dateOfTomorrowEndFromNowDate:_createDate];
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
