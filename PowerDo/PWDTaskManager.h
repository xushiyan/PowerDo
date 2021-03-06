//
//  PWDTaskManager.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/5/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@import UIKit;

@class PWDDailyRecord;
@class PWDTask;
@interface PWDTaskManager : NSObject

+ (instancetype _Nonnull)sharedManager;

@property (nonatomic,strong,readonly) NSManagedObjectContext * _Nonnull managedObjectContext;
@property (nonatomic,strong,readonly) NSManagedObjectModel * _Nonnull managedObjectModel;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator * _Nonnull persistentStoreCoordinator;

- (void)saveContext;
- (NSURL * _Nonnull)applicationDocumentsDirectory;

#pragma mark - Insert
- (PWDTask * _Nonnull)insertNewTaskForTomorrowWithTitle:(NSString  * _Nonnull)title inContext:(NSManagedObjectContext * _Nonnull)moc;
- (PWDDailyRecord * _Nonnull)insertNewDailyRecordWithTasks:(NSSet <PWDTask *>* _Nullable)tasks inContext:(NSManagedObjectContext * _Nonnull)moc;
- (PWDDailyRecord * _Nonnull)insertNewDailyRecordWithTasks:(NSSet <PWDTask *>* _Nullable)tasks date:(NSDate * _Nonnull)date inContext:(NSManagedObjectContext * _Nonnull)moc;

#pragma mark - Fetch
- (PWDDailyRecord * _Nullable)fetchLatestRecord;
- (NSArray <PWDTask *> * _Nullable)fetchTodayTasks;

@end
