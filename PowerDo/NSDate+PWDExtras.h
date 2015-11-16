//
//  NSDate+PWDExtras.h
//  PowerDo
//
//  Created by Xu, Raymond on 11/16/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PWDExtras)

+ (instancetype)dateOfTomorrowEnd;
+ (instancetype)dateOfTomorrowEndFromNowDate:(NSDate *)nowDate;

@end
