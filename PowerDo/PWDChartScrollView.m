//
//  PWDChartScrollView.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/22/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDChartScrollView.h"
#import "PWDChartView.h"

@implementation PWDChartScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        PWDChartView *chartView = [[PWDChartView alloc] initWithFrame:CGRectZero];
        chartView.showTrendLine = YES;
        chartView.backgroundColor = [UIColor whiteColor];
        chartView.opaque = YES;
        
        [self addSubview:chartView];
        self.chartView = chartView;
        self.delegate = chartView;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)updateChartDisplay {
    CGSize size = self.bounds.size;
    CGRect chartFrame = _chartView.frame;
    CGSize contentSize = self.contentSize;
    contentSize = CGSizeMake(CGRectGetWidth(chartFrame) + size.width, size.height);
    self.contentSize = contentSize;
    
    chartFrame.size.height = size.height;
    _chartView.frame = chartFrame;
    
    CGPoint center = _chartView.center;
    center.x = contentSize.width/2;
    _chartView.center = center;
}

- (void)updateChartWithRecords:(NSArray <PWDDailyRecord *> * _Nullable)records {
    CGSize size = self.bounds.size;
    CGFloat chartWidth = [_chartView updateRecords:records];
    self.contentSize = CGSizeMake(chartWidth + size.width, size.height);
    CGRect chartFrame = CGRectMake(0, 0, chartWidth, size.height);
    _chartView.frame = chartFrame;
    _chartView.center = CGPointMake(self.contentSize.width/2, _chartView.center.y);

    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)scrollToRecord:(PWDDailyRecord *)record {
    CGRect barRect = [_chartView barRectForRecord:record];
    CGRect convertedRect = [self convertRect:barRect fromView:_chartView];
    CGFloat midX = CGRectGetMidX(convertedRect);
    CGRect bounds = self.bounds;
    CGRect recordRect = CGRectMake(midX-CGRectGetWidth(bounds)/2, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    [self scrollRectToVisible:recordRect animated:YES];
}

- (void)unhighlightRecordAtIndex:(NSUInteger)index {
    PWDDailyRecord *record = _chartView.records[index];
    record.highlighted = NO;
    [_chartView setNeedsDisplay];
}

- (void)highlightRecordAtIndex:(NSUInteger)index {
    PWDDailyRecord *record = _chartView.records[index];
    record.highlighted = YES;
    [_chartView setNeedsDisplay];
}

- (void)scrollToMostRight {
    [self scrollRectToVisible:CGRectMake(self.contentSize.width-1, self.contentSize.height-1, 1, 1) animated:YES];
}

@end
