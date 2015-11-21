//
//  PWDTaskManager.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/5/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTaskManager.h"
#import "PWDConstants.h"
#import "PWDTask.h"
#import "PWDDailyRecord.h"
#import "NSDate+PWDExtras.h"

@implementation PWDTaskManager

+ (instancetype)sharedManager {
    static PWDTaskManager *sharedTaskManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTaskManager = [[self alloc] init];
    });
    return sharedTaskManager;
}

- (instancetype)init {
    if (self = [super init]) {
        // Initialize the managed object model
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PowerDo" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // Initialize the persistent store coordinator
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PowerDo.sqlite"];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                       configuration:nil
                                                                                                 URL:storeURL
                                                                                             options:@{
                                                                                                       NSMigratePersistentStoresAutomaticallyOption : @YES,
                                                                                                       NSInferMappingModelAutomaticallyOption : @YES
                                                                                                       }
                                                                                               error:&error];
        if (!persistentStore) {
            NSLog(@"persistentStore init error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Initialize the managed object context
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(postUpdateForTodayTasksCount:)
                                                     name:PWDTodayBadgeValueNeedsUpdateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSignificantTimeChange:)
                                                     name:UIApplicationSignificantTimeChangeNotification
                                                   object:nil];
        
    }
    return self;
}

- (BOOL)saveContext {
    NSError *error;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
        NSLog(@"managedObjectContext save error %@, %@", error, [error userInfo]);
        abort();
    }
    return success;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Insert
- (BOOL)insertNewTaskForTomorrowWithTitle:(NSString  * _Nonnull)title inContext:(NSManagedObjectContext * _Nonnull)moc {
    PWDTask *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    task.title = title;
    return task != nil && [self saveContext];
}

- (BOOL)insertNewDailyRecordWithPowerUnits:(float)powerUnits inContext:(NSManagedObjectContext * _Nonnull)moc {
    PWDDailyRecord *record = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDDailyRecord class]) inManagedObjectContext:moc];
    record.powerUnits = powerUnits;
    record.date = [NSDate dateOfTodayNoon];
    return record != nil && [self saveContext];
}

#pragma mark - Fetch
- (NSUInteger)fetchOnGoingTodayTasksCountInContext:(NSManagedObjectContext * _Nonnull)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    request.includesSubentities = NO;
    request.predicate = [NSPredicate predicateWithFormat:@"%@ == %ld AND %@ == %ld",
                         NSStringFromSelector(@selector(dueDateGroup)),
                         NSStringFromSelector(@selector(status)),
                         PWDTaskDueDateGroupToday,
                         PWDTaskStatusOnGoing];
    NSError *error;
    NSUInteger count = [moc countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
        NSLog(@"fetch count for %@ error: %@", [PWDTask class], error);
    }
    return count;
}

- (NSArray <PWDTask *> *)fetchInPlanTaskForTomorrowInContext:(NSManagedObjectContext  * _Nonnull)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"%@ == %ld AND %@ == %ld",
                         NSStringFromSelector(@selector(dueDateGroup)),
                         NSStringFromSelector(@selector(status)),
                         PWDTaskDueDateGroupTomorrow,
                         PWDTaskStatusInPlan];
    NSError *error;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"fetchInPlanTaskForTomorrow error: %@", error);
    }
    return results;
}

#pragma mark - Actions
- (void)postUpdateForTodayTasksCount:(NSNotification *)notification {
    NSManagedObjectContext *moc = self.managedObjectContext;
    if (notification.name == PWDTodayBadgeValueNeedsUpdateNotification) {
        NSUInteger count = [self fetchOnGoingTodayTasksCountInContext:moc];
        if (count != NSNotFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueChangeNotification object:@(count)];
        }
    }
}

- (void)handleSignificantTimeChange:(NSNotification *)notification {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSArray *tasksTomorrow = [self fetchInPlanTaskForTomorrowInContext:moc];
    __block float powerUnits = .0f;
    [tasksTomorrow enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        powerUnits += task.difficulty;
    }];
    powerUnits = 100/powerUnits;
    [self insertNewDailyRecordWithPowerUnits:powerUnits inContext:moc];
}

@end
