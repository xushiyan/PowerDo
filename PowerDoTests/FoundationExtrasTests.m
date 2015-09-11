//
//  FoundationExtrasTests.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FoundationExtras.h"

@interface FoundationExtrasTests : XCTestCase

@end

@implementation FoundationExtrasTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSDateExtras {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int hour = 12, minute = 17;
    NSDate *date = [NSDate dateFromHour:hour minute:minute];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    XCTAssertEqual(components.hour, hour);
    XCTAssertEqual(components.minute, minute);
}

@end
