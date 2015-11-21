//
//  PWDTask.m
//  PowerDo
//
//  Created by XU SHIYAN on 17/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTask.h"
#import "NSDate+PWDExtras.h"

@implementation PWDTask

- (void)awakeFromInsert {
    self.title = @"";
    NSDate *now = [NSDate date];
    self.createDateRaw = [now timeIntervalSince1970];
    NSDate *dueDate = [NSDate dateOfTomorrowEndFromNowDate:now];
    self.dueDateRaw = [dueDate timeIntervalSince1970];
    self.dueDateGroup = PWDTaskDueDateGroupTomorrow;
    self.difficulty = PWDTaskDifficultyEasy;
    self.status = PWDTaskStatusInPlan;
    self.sealed = NO;
}

- (NSDate *)createDate {
    return [NSDate dateWithTimeIntervalSince1970:self.createDateRaw];
}

- (void)setDueDate:(NSDate *)dueDate {
    self.dueDateRaw = [dueDate timeIntervalSince1970];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:dueDate]) {
        self.dueDateGroup = PWDTaskDueDateGroupToday;
    } else if ([calendar isDateInTomorrow:dueDate]) {
        self.dueDateGroup = PWDTaskDueDateGroupTomorrow;
    } else {
        self.dueDateGroup = PWDTaskDueDateGroupSomeDay;
    }
}

- (NSDate *)dueDate {
    return [NSDate dateWithTimeIntervalSince1970:self.dueDateRaw];
}

- (NSString *)dueDateGroupText {
    NSString *text;
    switch (self.dueDateGroup) {
        case PWDTaskDueDateGroupToday:
            text = NSLocalizedString(@"Due Today", @"PWDTaskDueDateGroupToday");
            break;
        case PWDTaskDueDateGroupTomorrow:
            text = NSLocalizedString(@"Due Tomorrow", @"PWDTaskDueDateGroupTomorrow");
            break;
        case PWDTaskDueDateGroupSomeDay:
            text = NSLocalizedString(@"Due Someday", @"PWDTaskDueDateGroupSomeDay");
            break;
    }
    return text;
}

- (NSString *)difficultyText {
    NSString *text;
    switch (self.difficulty) {
        case PWDTaskDifficultyEasy:
            text = NSLocalizedString(@"Easy", @"PWDTaskDifficultyEasy");
            break;
        case PWDTaskDifficultyMedium:
            text = NSLocalizedString(@"Medium", @"PWDTaskDifficultyMedium");
            break;
        case PWDTaskDifficultyHard:
            text = NSLocalizedString(@"Hard", @"PWDTaskDifficultyHard");
            break;
    }
    return text;
}

- (NSString *)statusText {
    NSString *text;
    switch (self.status) {
        case PWDTaskStatusInPlan:
            text = NSLocalizedString(@"In Plan", @"PWDTaskStatusInPlan");
            break;
        case PWDTaskStatusOnGoing:
            text = NSLocalizedString(@"On Going", @"PWDTaskStatusOnGoing");
            break;
        case PWDTaskStatusCompleted:
            text = NSLocalizedString(@"Completed", @"PWDTaskStatusCompleted");
            break;
    }
    return text;
}


@end
