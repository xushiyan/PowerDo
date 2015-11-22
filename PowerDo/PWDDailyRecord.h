//
//  PWDDailyRecord.h
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface PWDDailyRecord : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic,strong) NSDate *date;
@property (nonatomic) BOOL highlighted;
@property (nonatomic,strong,readonly) NSDateFormatter *chartDateFormatter;

- (void)updatePowerAndPowerUnits;
- (void)updatePower;
- (NSString *)powerText;
- (NSString *)dateTextForChart;

@end

NS_ASSUME_NONNULL_END

#import "PWDDailyRecord+CoreDataProperties.h"
