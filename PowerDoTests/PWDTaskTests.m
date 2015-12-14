//
//  PWDTaskTest.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PWDTask.h"
#import "PWDTaskManager.h"
#import "PWDConstants.h"

@interface PWDTaskTests : XCTestCase

@property (nonatomic,strong) PWDTask *task;

@end

@implementation PWDTaskTests

- (void)setUp {
    [super setUp];
    
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    NSEntityDescription *entityDescription = [taskManager.managedObjectModel entitiesByName][NSStringFromClass([PWDTask class])];
    self.task = [[PWDTask alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:taskManager.managedObjectContext];
}

- (void)tearDown {
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    [taskManager.managedObjectContext deleteObject:self.task];
    self.task = nil;
    [super tearDown];
}

- (void)testTaskInitialization {
    PWDTask *task = self.task;
    XCTAssertNotNil(task.title);
    
    NSDate *createDate = task.createDate;
    NSDate *dueDate = task.dueDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    XCTAssertTrue([calendar isDateInToday:createDate], @"Created date should be today.");
    
    // task created at or after cutoff time
    XCTAssertTrue([calendar isDateInTomorrow:dueDate], @"dueDate should be at tomorrow.");
    
    NSDate *megaTomorrowStart = [dueDate dateByAddingTimeInterval:1];
    NSDate *megaTomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:2 toDate:createDate options:0];
    XCTAssertTrue([calendar isDate:megaTomorrowStart inSameDayAsDate:megaTomorrow], @"dueDate should be at the end of the tomorrow.");
    
    NSComparisonResult result = [dueDate compare:createDate];
    // we do not consider extreme case in which task is created in the last millisecond of today
    XCTAssertNotEqual(result, NSOrderedAscending, @"dueDate should not be earlier than createDate.");
    
    XCTAssertEqual(task.dueDateGroup, PWDTaskDueDateGroupTomorrow);
    XCTAssertEqual(task.difficulty, PWDTaskDifficultyEasy);
    XCTAssertEqual(task.status, PWDTaskStatusInPlan);
    XCTAssertFalse(task.sealed);
}

@end
