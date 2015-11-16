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

- (void)drawRect:(CGRect)rect {
    PWDTaskDifficulty difficulty = self.difficulty;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint start = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    [path moveToPoint:start];
    CGPoint end = CGPointMake(CGRectGetMaxX(rect) * difficulty/PWDTaskDifficultyHard, CGRectGetMidY(rect));
    [path addLineToPoint:end];
    path.lineWidth = CGRectGetHeight(rect);
    UIColor *drawColor = [UIColor colorFromTaskDifficulty:difficulty];
    [drawColor setStroke];
    [path stroke];
}


@end
