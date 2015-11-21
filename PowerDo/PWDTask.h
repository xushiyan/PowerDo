//
//  PWDTask.h
//  PowerDo
//
//  Created by XU SHIYAN on 17/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PWDTaskDueDateGroup) {
    PWDTaskDueDateGroupToday,
    PWDTaskDueDateGroupTomorrow,
    PWDTaskDueDateGroupSomeDay,
};

typedef NS_ENUM(NSUInteger, PWDTaskDifficulty) {
    PWDTaskDifficultyEasy = 1,
    PWDTaskDifficultyMedium = 2,
    PWDTaskDifficultyHard = 3,
};

typedef NS_ENUM(NSUInteger, PWDTaskStatus) {
    PWDTaskStatusInPlan,
    PWDTaskStatusOnGoing,
    PWDTaskStatusCompleted,
};

@interface PWDTask : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic,strong,readonly) NSDate *createDate;
@property (nonatomic,strong) NSDate *dueDate;

- (NSString *)dueDateGroupText;
- (NSString *)difficultyText;
- (NSString *)statusText;

@end

NS_ASSUME_NONNULL_END

#import "PWDTask+CoreDataProperties.h"
