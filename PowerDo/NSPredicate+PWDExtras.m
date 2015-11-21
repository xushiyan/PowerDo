//
//  NSPredicate+PWDExtras.m
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "NSPredicate+PWDExtras.h"
#import "PWDTask.h"

@implementation NSPredicate (PWDExtras)

+ (instancetype _Nonnull)predicateForTodayTasks {
    return [NSPredicate predicateWithFormat:@"%K == %ld AND %K == NO",
            NSStringFromSelector(@selector(dueDateGroup)),
            PWDTaskDueDateGroupToday,
            NSStringFromSelector(@selector(sealed))];
}

@end
