//
//  PWDTaskManager.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/5/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoundationExtras.h"
@import CoreData;

@interface PWDTaskManager : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

DECLARE_DEFAULT_SINGLETON_FOR_CLASS(PWDTaskManager)
