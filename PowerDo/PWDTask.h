//
//  PWDTask.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PWDTaskDifficulty) {
    PWDTaskDifficultyEasy = 1,
    PWDTaskDifficultyMedium = 2,
    PWDTaskDifficultyHard = 3,
};

@interface PWDTask : NSObject

- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,getter=isCompleted) BOOL completed;
@property (nonatomic,strong,readonly) NSDate *createDate;
@property (nonatomic,strong) NSDate *dueDate;
@property (nonatomic) enum PWDTaskDifficulty difficulty;

@end
