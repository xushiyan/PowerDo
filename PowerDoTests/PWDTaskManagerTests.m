//
//  PWDTaskManagerTests.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/5/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PWDTaskManager.h"

@interface PWDTaskManagerTests : XCTestCase

@property (nonatomic,strong) PWDTaskManager *taskManager;

@end

@implementation PWDTaskManagerTests

- (void)setUp {
    [super setUp];
    self.taskManager = [PWDTaskManager sharedManager];
}

- (void)tearDown {
    self.taskManager = nil;
    [super tearDown];
}

- (void)testTaskManagerIsSingleton {
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    XCTAssertTrue(taskManager == self.taskManager);
}

@end
