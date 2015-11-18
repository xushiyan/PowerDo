//
//  PWDTaskManager.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/5/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTaskManager.h"
#import "PWDConstants.h"

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
                                                                                             options:@{NSMigratePersistentStoresAutomaticallyOption : @YES,
                                                                                                       NSInferMappingModelAutomaticallyOption : @YES}
                                                                                               error:&error];
        if (!persistentStore) {
            NSLog(@"persistentStore init error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Initialize the managed object context
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return self;
}

- (void)saveContext {
    NSError *error;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
