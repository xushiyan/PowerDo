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
#import "FoundationExtras.h"

@interface PWDTaskTests : XCTestCase

@property (nonatomic,strong) PWDTask *task;
@property (nonatomic,strong) NSDate *cutoffTime;

@end

@implementation PWDTaskTests

- (void)setUp {
    [super setUp];
    
    self.task = [[PWDTask alloc] initWithTitle:@"sample task"];
    self.cutoffTime = [[PWDTaskManager defaultInstance] cutoffTimeForDate:self.task.createDate];
}

- (void)tearDown {
    self.task = nil;
    self.cutoffTime = nil;
    [super tearDown];
}

- (void)testTaskMustHaveTitleAndCreateDate {
    PWDTask *task1 = [[PWDTask alloc] init];
    XCTAssertNotNil(task1.title);
    XCTAssertNotNil(task1.createDate);
    task1.title = nil;
    XCTAssertNotNil(task1.title);
    
    
    PWDTask *task2 = [[PWDTask alloc] initWithTitle:nil];
    XCTAssertNotNil(task2.title);
    XCTAssertNotNil(task2.createDate);
    
    
    PWDTask *task3 = [[PWDTask alloc] initWithTitle:@""];
    XCTAssertNotNil(task3.title);
    task3.title = nil;
    XCTAssertNotNil(task3.title);
    XCTAssertNotNil(task3.createDate);

}

- (void)testTaskIsNotCompletedAtFirst {
    PWDTask *task = self.task;
    XCTAssertFalse(task.completed);
}

- (void)testTaskIsDueTodayOrTomorrow {
    
    NSDate *cutoffTime = self.cutoffTime;
    PWDTask *task = self.task;
    NSDate *createDate = task.createDate;
    NSDate *dueDate = task.dueDate;
    XCTAssertNotNil(dueDate);
    XCTAssertNotNil(createDate);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    XCTAssertTrue([calendar isDateInToday:createDate], @"Created date should be today.");
    
    NSComparisonResult cutoffCompare = [calendar compareDate:createDate toDate:cutoffTime toUnitGranularity:NSCalendarUnitMinute];
    if (cutoffCompare == NSOrderedAscending) {
        // task created before cutoff time
        XCTAssertTrue([calendar isDateInToday:dueDate], @"dueDate should be at today.");
        XCTAssertTrue([calendar isDate:createDate inSameDayAsDate:dueDate], @"dueDate should be at the same day as createDate");
        
        NSDate *tomorrowStart = [dueDate dateByAddingTimeInterval:1];
        XCTAssertTrue([calendar isDateInTomorrow:tomorrowStart], @"dueDate should be at the end of today.");
        
    } else {
        // task created at or after cutoff time
        XCTAssertTrue([calendar isDateInTomorrow:dueDate], @"dueDate should be at tomorrow.");
        
        NSDate *megaTomorrowStart = [dueDate dateByAddingTimeInterval:1];
        NSDate *megaTomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:2 toDate:createDate options:0];
        XCTAssertTrue([calendar isDate:megaTomorrowStart inSameDayAsDate:megaTomorrow], @"dueDate should be at the end of the tomorrow.");
    }

    NSComparisonResult result = [dueDate compare:createDate];
    // we do not consider extreme case in which task is created in the last millisecond of today
    XCTAssertNotEqual(result, NSOrderedAscending, @"dueDate should not be earlier than createDate.");
    
}

- (void)testTaskDueDateIsModifiable {
    PWDTask *task = self.task;
    NSDate *createDate = task.createDate;
    task.dueDate = [NSDate distantFuture];
    NSComparisonResult result1 = [task.dueDate compare:createDate];
    XCTAssertNotEqual(result1, NSOrderedAscending, @"dueDate should not be earlier than createDate.");
    
    task.dueDate = [NSDate distantPast];
    NSComparisonResult result2 = [task.dueDate compare:createDate];
    XCTAssertNotEqual(result2, NSOrderedAscending, @"dueDate should not be earlier than createDate.");
    XCTAssertEqualObjects(task.dueDate, [NSDate distantFuture], @"Invalid dueDate won't be set.");
    
    task.dueDate = createDate;
    NSComparisonResult result3 = [task.dueDate compare:createDate];
    XCTAssertEqual(result3, NSOrderedSame);
    XCTAssertEqualObjects(task.dueDate, createDate);
}

- (void)testTaskHasEasyDifficultyByDefault {
    PWDTask *task = self.task;
    XCTAssertEqual(task.difficulty, PWDTaskDifficultyEasy, @"By default, newly created task has easy difficulty.");
}

@end
