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

+ (instancetype _Nonnull)sharedManager;

@property (nonatomic,strong,readonly) NSManagedObjectContext * _Nonnull managedObjectContext;
@property (nonatomic,strong,readonly) NSManagedObjectModel * _Nonnull managedObjectModel;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator * _Nonnull persistentStoreCoordinator;

- (BOOL)saveContext;
- (NSURL * _Nonnull)applicationDocumentsDirectory;

#pragma mark - Insert
- (BOOL)insertNewTaskForTomorrowWithTitle:(NSString  * _Nonnull)title inContext:(NSManagedObjectContext * _Nonnull)moc;

#pragma mark - Fetch

@end
