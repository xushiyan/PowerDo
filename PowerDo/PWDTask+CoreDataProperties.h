//
//  PWDTask+CoreDataProperties.h
//  PowerDo
//
//  Created by XU SHIYAN on 17/11/15.
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
@property (nonatomic) NSTimeInterval dueDateRaw;
@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) BOOL sealed;
@property (nonatomic) int16_t status;
@property (nonatomic) float points;

@end

NS_ASSUME_NONNULL_END
