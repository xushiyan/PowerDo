//
//  PWDChartView.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/22/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDChartView.h"
#import "UIColor+Extras.h"

CGFloat const ChartBarWidth = 40.0f;
CGFloat const ChartBarSpacing = 8.0f;
CGFloat const ChartBarTopMargin = 20.0f;

@implementation PWDChartView

- (CGFloat)updateRecords:(NSArray <PWDDailyRecord *> * _Nullable)records {
    self.records = records;
    
    CGFloat newWidth = records.count * (ChartBarWidth + ChartBarSpacing) + ChartBarSpacing;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    return newWidth;
}

- (CGRect)viewingRectForRecord:(PWDDailyRecord *)record {
    NSUInteger index = [_records indexOfObject:record];
    CGFloat recordBottomCenter = (_records.count - 1 - index) * (ChartBarWidth+ChartBarSpacing) + ChartBarWidth/2+ChartBarSpacing;
    CGRect rectToView = CGRectMake(recordBottomCenter - ChartBarWidth/2 - ChartBarSpacing,
                                   0,
                                   ChartBarWidth + 2*ChartBarSpacing,
                                   CGRectGetHeight(self.bounds));
    return rectToView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat yAxis0 = CGRectGetMaxY(rect);
    CGFloat pointsPerPower = (CGRectGetHeight(rect)-ChartBarTopMargin) / 100;
    NSUInteger count = _records.count;
    [_records enumerateObjectsUsingBlock:^(PWDDailyRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint barBottomCenter = CGPointMake((count - 1 - idx) * (ChartBarWidth+ChartBarSpacing) + ChartBarWidth/2+ChartBarSpacing, yAxis0);
        [path moveToPoint:barBottomCenter];
        CGPoint barTopCenter = CGPointMake(barBottomCenter.x, yAxis0 - pointsPerPower * obj.power);
        [path addLineToPoint:barTopCenter];
        if (obj.highlighted) {
            [[UIColor flatOrangeColor] setStroke];
        } else {
            [[UIColor themeColor] setStroke];
        }
        
        path.lineWidth = ChartBarWidth;
        [path stroke];
    }];

}


@end
