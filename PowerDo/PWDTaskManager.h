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

@interface PWDTaskManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)insertNewTaskForTomorrowWithTitle:(NSString  * _Nonnull)title inContext:(NSManagedObjectContext * _Nonnull)moc;

@end
