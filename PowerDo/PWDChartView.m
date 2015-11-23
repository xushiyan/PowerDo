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
CGFloat const ChartBarTopMargin = 36.0f;
CGFloat const ChartBarDateTextRectHeight = 44.0f;
CGFloat const ChartBarPowerTextRectHeight = 20.0f;
CGFloat const ChartTrendDotRadius = 4.0f;
CGFloat const ChartBarBaseHeight = 10.0f;
CGFloat const ChartTrendDotYOffset = ChartBarBaseHeight + ChartBarDateTextRectHeight + ChartBarBaseHeight;

@implementation PWDChartView {
    PWDDailyRecord *_lastHighlightRecord;
}

- (CGFloat)updateRecords:(NSArray <PWDDailyRecord *> * _Nullable)records {
    
    self.records = records;
    
    CGFloat newWidth = records.count * (ChartBarWidth + ChartBarSpacing) + ChartBarSpacing;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    return newWidth;
}

- (CGRect)barRectForRecord:(PWDDailyRecord *)record {
    NSUInteger index = [_records indexOfObject:record];
    CGFloat recordBottomCenter = (_records.count - 1 - index) * (ChartBarWidth+ChartBarSpacing) + ChartBarWidth/2+ChartBarSpacing;
    CGRect centerRect = CGRectMake(recordBottomCenter-ChartBarWidth/2, 0, ChartBarWidth, CGRectGetHeight(self.bounds));
    return centerRect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat yAxis0 = CGRectGetMaxY(rect);
    CGFloat fullBarHeight;
    if (self.showTrendLine) {
        fullBarHeight = CGRectGetHeight(rect) / 2;
    } else {
        fullBarHeight = CGRectGetHeight(rect) - ChartBarTopMargin;
    }
    CGFloat pointsPerPower = fullBarHeight / 100;
    NSUInteger count = _records.count;
    CGPoint *barBottomCenterArr = calloc(count, sizeof(CGPoint));
    CGPoint *barTopCenterArr = calloc(count, sizeof(CGPoint));
    
    __block NSUInteger highlightedIndex = NSIntegerMax;
    [_records enumerateObjectsUsingBlock:^(PWDDailyRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint barBottomCenter = CGPointMake((count - 1 - idx) * (ChartBarWidth+ChartBarSpacing) + ChartBarWidth/2+ChartBarSpacing, yAxis0);
        barBottomCenterArr[idx] = barBottomCenter;
        [path moveToPoint:barBottomCenter];
        CGPoint barTopCenter = CGPointMake(barBottomCenter.x, yAxis0 - pointsPerPower * obj.power - ChartBarBaseHeight);
        barTopCenterArr[idx] = barTopCenter;
        [path addLineToPoint:barTopCenter];
        if (obj.highlighted) {
            highlightedIndex = idx;
            [[UIColor flatOrangeColor] setStroke];
        } else {
            [[UIColor themeColor] setStroke];
        }
        
        path.lineWidth = ChartBarWidth;
        [path stroke];
    }];
    
    if (self.showTrendLine) {
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        CGPoint *dotPoints = calloc(count, sizeof(CGPoint));
        UIBezierPath *trendLine = [UIBezierPath bezierPath];
        [_records enumerateObjectsUsingBlock:^(PWDDailyRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = CGPointMake(barBottomCenterArr[idx].x, barTopCenterArr[idx].y - (CGRectGetHeight(rect)/2) + ChartTrendDotYOffset);
            dotPoints[idx] = point;
            
            CGRect powerTextRect = CGRectMake(point.x - ChartBarWidth/2, barTopCenterArr[idx].y - ChartBarPowerTextRectHeight, ChartBarWidth, ChartBarPowerTextRectHeight);
            [obj.powerText drawInRect:powerTextRect
                       withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                        NSParagraphStyleAttributeName:paragraph}];
            
            CGRect dateTextRect = CGRectMake(point.x - ChartBarWidth/2, ChartBarBaseHeight, ChartBarWidth, ChartBarDateTextRectHeight);
            NSString * dateText = obj.dateTextForChart;
            [dateText drawInRect:dateTextRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                               NSParagraphStyleAttributeName:paragraph}];
            if (idx == 0) {
                [trendLine moveToPoint:point];
            } else {
                [trendLine addLineToPoint:point];
            }
            [[UIColor grayColor] setStroke];
            [trendLine stroke];
        }];
        
        [[UIColor grayColor] setStroke];
        for (int i=0; i<count; ++i) {
            CGRect dotRect = CGRectMake(dotPoints[i].x - ChartTrendDotRadius, dotPoints[i].y - ChartTrendDotRadius, ChartTrendDotRadius*2, ChartTrendDotRadius*2);
            UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:dotRect];
            dotPath.lineWidth = 1;
            if (highlightedIndex != NSIntegerMax && i == highlightedIndex) {
                [[UIColor flatOrangeColor] setFill];
            } else {
                [[UIColor themeColor] setFill];
            }
            [dotPath fill];
            [dotPath stroke];
        }
        
        free(dotPoints);
    }
    
    free(barBottomCenterArr);
    free(barTopCenterArr);

}

- (void)redrawForScrollOffset:(CGFloat)offsetX {
    NSUInteger idx = offsetX/(ChartBarWidth+ChartBarSpacing);
    if (idx < _records.count) {
        PWDDailyRecord *record = _records[_records.count - 1 - idx];
        CGRect rect = [self barRectForRecord:record];
        CGFloat minx = CGRectGetMinX(rect);
        CGFloat maxx = CGRectGetMaxX(rect);
        if (offsetX > minx && offsetX < maxx) {
            if (record.highlighted == NO) {
                record.highlighted = YES;
                
                if (!_lastHighlightRecord) {
                    _lastHighlightRecord = record;
                }
                if (_lastHighlightRecord != record) {
                    _lastHighlightRecord.highlighted = NO;
                    CGRect rectUnhighlight = [self barRectForRecord:_lastHighlightRecord];
                    rect = CGRectUnion(rect, rectUnhighlight);
                    _lastHighlightRecord = record;
                }
                [self setNeedsDisplayInRect:rect];
                
            }
            
        }
    }
}

- (void)clearHighlights {
    _lastHighlightRecord = nil;
    [_records enumerateObjectsUsingBlock:^(PWDDailyRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.highlighted = NO;
    }];
    [self setNeedsDisplay];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.showTrendLine) {
        [self redrawForScrollOffset:scrollView.contentOffset.x];
    }
}

@end
