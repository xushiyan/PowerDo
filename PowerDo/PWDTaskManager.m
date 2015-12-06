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
#import "NSPredicate+PWDExtras.h"
@import PowerKit;

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
                                                     name:PWDDayChangeNotification
                                                   object:[UIApplication sharedApplication]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTodayTasksManualChange:)
                                                     name:PWDTodayTasksManualChangeNotification
                                                   object:nil];
#ifdef DEBUG
        [self deleteAllEntities];
        [self createSampleData];
#endif
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

- (PWDDailyRecord *)insertNewDailyRecordWithTasks:(NSSet <PWDTask *>* _Nullable)tasks date:(NSDate * _Nonnull)date inContext:(NSManagedObjectContext * _Nonnull)moc {
    PWDDailyRecord *record = [self insertNewDailyRecordWithTasks:tasks inContext:moc];
    record.date = date;
    [self saveContext];
    return record;
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

- (PWDDailyRecord *)fetchLatestRecord {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PWDDailyRecord class]) inManagedObjectContext:self.managedObjectContext];
    request.fetchLimit = 1;
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(dateRaw)) ascending:NO];
#ifdef DEBUG
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(createDateRaw)) ascending:YES];
    request.sortDescriptors = @[sort1,sort2];
#else
    request.sortDescriptors = @[sort1];
#endif
    NSError *error;
    PWDDailyRecord *record = [[self.managedObjectContext executeFetchRequest:request error:&error] firstObject];
    if (error) {
        NSLog(@"fetchLatestRecord error: %@", error);
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

#pragma mark - Delete
- (void)deleteAllEntities {
    __block NSError *error = nil;
    NSArray *entities = [self.managedObjectModel entities];
    [entities enumerateObjectsUsingBlock:^(NSEntityDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:obj.name];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&error];
        
    }];
    if (error) {
        NSLog(@"Delete error: %@", error);
    }
}

#pragma mark - Actions
- (void)createSampleData {
    NSManagedObjectContext *moc = self.managedObjectContext;
    PWDTask *task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Shopping for Chirstmas", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyMedium;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Finish reading Chapter 6", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyHard;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Submit Problem Set 2", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyHard;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Book flight to China", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyEasy;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Cut hair", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyEasy;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Finish reading Chapter 7", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyHard;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Prepare final presentation", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyHard;
    task = [self insertNewTaskForTomorrowWithTitle:NSLocalizedString(@"Send gift to Raymond", @"Sample task title") inContext:moc];
    task.difficulty = PWDTaskDifficultyMedium;
    [self saveContext];
}

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
    PWDDailyRecord *todayRecord = [self fetchLatestRecord];
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

#ifdef DEBUG
    PWDDailyRecord *record = [self insertNewDailyRecordWithTasks:newTodayTaskSet inContext:moc];
    PWDDailyRecord *lastestRecord = [self fetchLatestRecord];
    if (lastestRecord != record) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *newFakeDate = [cal dateByAddingUnit:NSCalendarUnitDay value:1 toDate:lastestRecord.date options:0];
        record.date = newFakeDate;
        [self saveContext];
    }
#else
    [self insertNewDailyRecordWithTasks:newTodayTaskSet inContext:moc];
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
}



@end
