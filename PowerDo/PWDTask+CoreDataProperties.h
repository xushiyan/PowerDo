//
//  PWDTask+CoreDataProperties.h
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDTask (CoreDataProperties)

@property (nonatomic) NSTimeInterval createDateRaw;
@property (nonatomic) int16_t difficulty;
@property (nonatomic) int16_t dueDateGroup;
@property (nonatomic) NSTimeInterval dueDateRaw;
@property (nonatomic) BOOL sealed;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) PWDDailyRecord *dailyRecord;

@end

NS_ASSUME_NONNULL_END
