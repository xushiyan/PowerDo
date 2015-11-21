//
//  PWDDailyRecord.m
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDDailyRecord.h"

@implementation PWDDailyRecord

-(void)setDate:(NSDate *)date {
    self.dateRaw = [date timeIntervalSince1970];
}

- (NSDate *)date {
    return [NSDate dateWithTimeIntervalSince1970:self.dateRaw];
}

@end
