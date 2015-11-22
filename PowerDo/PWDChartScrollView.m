//
//  PWDChartScrollView.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/22/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDChartScrollView.h"
#import "PWDChartView.h"

@implementation PWDChartScrollView {
    __weak PWDChartView *_chartView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        PWDChartView *chartView = [[PWDChartView alloc] initWithFrame:CGRectZero];
        chartView.backgroundColor = [UIColor whiteColor];
        chartView.opaque = YES;
        [self addSubview:chartView];
        _chartView = chartView;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)updateChartDisplay {
    CGSize size = self.bounds.size;
    CGRect chartViewFrame = _chartView.frame;
    chartViewFrame.size.height = size.height;
    _chartView.frame = chartViewFrame;
    self.contentSize = _chartView.frame.size;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)updateChartWithRecords:(NSArray <PWDDailyRecord *> * _Nullable)records {
    CGSize size = self.bounds.size;
    CGFloat width = [_chartView updateRecords:records];
    _chartView.frame = CGRectMake(0, 0, width, size.height);
    self.contentSize = _chartView.frame.size;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)scrollToRecord:(PWDDailyRecord *)record {
    CGRect viewingRect = [_chartView viewingRectForRecord:record];
    [self scrollRectToVisible:viewingRect animated:YES];
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
