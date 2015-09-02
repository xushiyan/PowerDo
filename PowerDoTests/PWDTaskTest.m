//
//  PWDTaskTest.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PWDTask.h"

@interface PWDTaskTest : XCTestCase

@property (nonatomic,strong) PWDTask *task;

@end

@implementation PWDTaskTest

- (void)setUp {
    [super setUp];
    self.task = [[PWDTask alloc] initWithTitle:@"sample task"];
}

- (void)tearDown {
    self.task = nil;
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

- (void)testTaskIsDueTodayByDefault {
    PWDTask *task = self.task;
    NSDate *createDate = task.createDate;
    NSDate *dueDate = task.dueDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    XCTAssertTrue([calendar isDate:createDate inSameDayAsDate:dueDate]);
}

- (void)testDueDateIsNotBeforeCreateDate {
    PWDTask *task = self.task;
    NSDate *dueDate = task.dueDate;
    NSDate *createDate = task.createDate;
    XCTAssertNotNil(dueDate);
    XCTAssertNotNil(createDate);
    NSComparisonResult result = [dueDate compare:createDate];
    XCTAssertTrue(result != NSOrderedAscending);
}

@end
