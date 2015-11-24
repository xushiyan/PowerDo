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
#import "NSPredicate+PWDExtras.h"

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
                                                 selector:@selector(handleDayChange:)
                                                     name:NSCalendarDayChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTodayTasksManualChange:)
                                                     name:PWDTodayTasksManualChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)saveContext {
    NSError *error;
    BOOL success = [self.managedObjectContext save:&error];
    if ([self.managedObjectContext hasChanges] && !success) {
        NSLog(@"managedObjectContext save error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Insert
- (PWDTask *)insertNewTaskForTodayWithTitle:(NSString  * _Nonnull)title inContext:(NSManagedObjectContext * _Nonnull)moc {
    PWDTask *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    task.title = title;
    task.dueDate = [NSDate dateOfTodayEnd];
    task.status = PWDTaskStatusOnGoing;
    [self saveContext];
    return task;
}

- (PWDTask *)insertNewTaskForTomorrowWithTitle:(NSString  * _Nonnull)title inContext:(NSManagedObjectContext * _Nonnull)moc {
    PWDTask *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    task.title = title;
    [self saveContext];
    return task;
}

- (PWDDailyRecord *)insertNewDailyRecordWithTasks:(NSSet <PWDTask *>* _Nullable)tasks inContext:(NSManagedObjectContext * _Nonnull)moc {
    NSDate * const now = [NSDate date];
    [tasks enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, BOOL * _Nonnull stop) {
        task.dueDate = [NSDate dateOfTodayEndFromNowDate:now];
        task.status = PWDTaskStatusOnGoing;
    }];

    PWDDailyRecord *record = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDDailyRecord class]) inManagedObjectContext:moc];
    [record addTasks:tasks];
    [record updatePowerAndPowerUnits];
    [self saveContext];
    return record;
}

#pragma mark - Fetch
- (PWDDailyRecord *)fetchTodayRecord {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDDailyRecord class]) inManagedObjectContext:self.managedObjectContext];
    request.fetchLimit = 1;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(createDateRaw)) ascending:NO];
    request.sortDescriptors = @[sort];
    NSError *error;
    PWDDailyRecord *record = [[self.managedObjectContext executeFetchRequest:request error:&error] firstObject];
    if (error) {
        NSLog(@"fetchTodayRecord error: %@", error);
    }
    return record;
}

- (NSArray <PWDTask *> *)fetchTodayTasks {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateForTodayTasks];
    NSError *error;
    NSArray *todayTasks = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"fetch today tasks error: %@", error);
    }
    return todayTasks;
}

- (NSUInteger)fetchOnGoingTodayTasksCountInContext:(NSManagedObjectContext * _Nonnull)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    request.includesSubentities = NO;
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %ld AND %K == %ld AND %K == NO",
                         NSStringFromSelector(@selector(dueDateGroup)),
                         PWDTaskDueDateGroupToday,
                         NSStringFromSelector(@selector(status)),
                         PWDTaskStatusOnGoing,
                         NSStringFromSelector(@selector(sealed))];
    NSError *error;
    NSUInteger count = [moc countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
        NSLog(@"fetch count for %@ error: %@", [PWDTask class], error);
    }
    return count;
}

- (NSArray <PWDTask *> * _Nullable)fetchInPlanTaskForTomorrowInContext:(NSManagedObjectContext  * _Nonnull)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDTask class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %ld AND %K == %ld",
                         NSStringFromSelector(@selector(dueDateGroup)),
                         PWDTaskDueDateGroupTomorrow,
                         NSStringFromSelector(@selector(status)),
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

- (void)handleTodayTasksManualChange:(NSNotification *)notification {
    NSArray *todayTasks = [self fetchTodayTasks];
    PWDDailyRecord *todayRecord = [self fetchTodayRecord];
    if (todayRecord) {
        [todayRecord addTasks:[NSSet setWithArray:todayTasks]];
        [todayRecord updatePower];
    } else {
        todayRecord = [self insertNewDailyRecordWithTasks:[NSSet setWithArray:todayTasks] inContext:self.managedObjectContext];
        [todayRecord resetPowerAndPowerUnits];
    }
    [self saveContext];
}

- (void)handleDayChange:(NSNotification *)notification {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSArray *inPlanTasks = [self fetchInPlanTaskForTomorrowInContext:moc];
    NSMutableSet *newTodayTaskSet = [NSMutableSet setWithArray:inPlanTasks];
    
    NSMutableSet *oldTodayTaskSet = [NSMutableSet setWithArray:[self fetchTodayTasks]];
    [oldTodayTaskSet enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, BOOL * _Nonnull stop) {
        if (task.status == PWDTaskStatusOnGoing) {
            PWDTask *onGoingTaskClone = [self insertNewTaskForTodayWithTitle:task.title inContext:moc];
            onGoingTaskClone.difficulty = task.difficulty;
            [newTodayTaskSet addObject:onGoingTaskClone];
        }
    }];
    [oldTodayTaskSet makeObjectsPerformSelector:@selector(setSealed:) withObject:@YES];

    [self insertNewDailyRecordWithTasks:newTodayTaskSet inContext:moc];
}



@end
