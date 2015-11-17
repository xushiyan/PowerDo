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

// Insert code here to add functionality to your managed object subclass
- (void)awakeFromInsert {
    self.title = @"";
    NSDate *now = [NSDate date];
    self.createDateRaw = [now timeIntervalSince1970];
    self.dueDateRaw = [[NSDate dateOfTomorrowEndFromNowDate:now] timeIntervalSince1970];
    self.difficulty = PWDTaskDifficultyEasy;
    self.status = PWDTaskStatusInPlan;
    self.points = .0f;
    self.sealed = NO;
}

- (NSDate *)createDate {
    return [NSDate dateWithTimeIntervalSince1970:self.createDateRaw];
}

- (void)setDueDate:(NSDate *)dueDate {
    self.dueDateRaw = [dueDate timeIntervalSince1970];
}

- (NSDate *)dueDate {
    return [NSDate dateWithTimeIntervalSince1970:self.dueDateRaw];
}

- (PWDTaskDueDateGroup)dueDateGroup {
    NSDate *dueDate = [NSDate dateWithTimeIntervalSince1970:self.dueDateRaw];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:dueDate]) {
        return PWDTaskDueDateGroupToday;
    } else if ([calendar isDateInTomorrow:dueDate]) {
        return PWDTaskDueDateGroupTomorrow;
    } else {
        return PWDTaskDueDateGroupSomeDay;
    }
}

- (NSString *)dueDateGroupText {
    NSString *text;
    switch (self.dueDateGroup) {
        case PWDTaskDueDateGroupToday:
            text = NSLocalizedString(@"Today", @"PWDTaskDueDateGroupToday");
            break;
        case PWDTaskDueDateGroupTomorrow:
            text = NSLocalizedString(@"Tomorrow", @"PWDTaskDueDateGroupTomorrow");
            break;
        case PWDTaskDueDateGroupSomeDay:
            text = NSLocalizedString(@"Someday", @"PWDTaskDueDateGroupSomeDay");
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
