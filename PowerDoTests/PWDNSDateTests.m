//
//  PWDNSDateTests.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/16/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+PWDExtras.h"

@interface PWDNSDateTests : XCTestCase

@end

@implementation PWDNSDateTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateOfEndTomorrow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *tomorrowEnd = [NSDate dateOfTomorrowEndFromNowDate:now];
    NSDate *megaTomorrowStart = [tomorrowEnd dateByAddingTimeInterval:1];
    NSDate *expected = [calendar dateByAddingUnit:NSCalendarUnitDay value:2 toDate:now options:0];
    expected = [calendar startOfDayForDate:expected];
    XCTAssertEqualObjects(megaTomorrowStart, expected);
}

@end
