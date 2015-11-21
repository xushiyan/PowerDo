//
//  PWDDailyRecord+CoreDataProperties.h
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDDailyRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDDailyRecord (CoreDataProperties)

@property (nonatomic) NSTimeInterval dateRaw;
@property (nonatomic) float power;
@property (nonatomic) float powerUnits;
@property (nullable, nonatomic, retain) NSSet<PWDTask *> *tasks;

@end

@interface PWDDailyRecord (CoreDataGeneratedAccessors)

- (void)addTasksObject:(PWDTask *)value;
- (void)removeTasksObject:(PWDTask *)value;
- (void)addTasks:(NSSet<PWDTask *> *)values;
- (void)removeTasks:(NSSet<PWDTask *> *)values;

@end

NS_ASSUME_NONNULL_END
