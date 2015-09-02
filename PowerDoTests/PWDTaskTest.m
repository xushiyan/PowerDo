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

@end

@implementation PWDTaskTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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


@end
