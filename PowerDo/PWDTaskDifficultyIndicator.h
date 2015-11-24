//
//  PWDTaskDifficultyIndicator.h
//  PowerDo
//
//  Created by Xu, Raymond on 11/16/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDTask.h"

@interface PWDTaskDifficultyIndicator : UIView

- (instancetype)initWithFixedFrame;
@property (nonatomic) PWDTaskDifficulty difficulty;

@end
