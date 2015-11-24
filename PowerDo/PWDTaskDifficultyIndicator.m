//
//  PWDTaskDifficultyIndicator.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/16/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTaskDifficultyIndicator.h"
#import "UIColor+Extras.h"

@implementation PWDTaskDifficultyIndicator

- (instancetype)initWithFixedFrame {
    return [self initWithFrame:CGRectMake(0, 0, 60, 20)];
}

- (void)drawRect:(CGRect)rect {
    PWDTaskDifficulty difficulty = self.difficulty;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint start = CGPointMake(CGRectGetMinX(rect)+8.0f, CGRectGetMidY(rect));
    [path moveToPoint:start];
    CGPoint end = CGPointMake(CGRectGetMaxX(rect) * difficulty/PWDTaskDifficultyHard, CGRectGetMidY(rect));
    [path addLineToPoint:end];
    path.lineWidth = CGRectGetHeight(rect);
    UIColor *drawColor = [UIColor colorFromTaskDifficulty:difficulty];
    [drawColor setStroke];
    [path stroke];
}


@end
