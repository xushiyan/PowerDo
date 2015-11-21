//
//  NSPredicate+PWDExtras.h
//  PowerDo
//
//  Created by XU SHIYAN on 21/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface NSPredicate (PWDExtras)

+ (instancetype _Nonnull)predicateForTodayTasks;

@end
