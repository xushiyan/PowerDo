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

- (void)updateChartWithRecords:(NSArray <PWDDailyRecord *> * _Nullable)records {
    CGSize viewSize = self.bounds.size;
    CGFloat width = [_chartView updateRecords:records];
    _chartView.frame = CGRectMake(0, 0, width, viewSize.height);
    self.contentSize = _chartView.frame.size;
    [self setNeedsDisplay];
    [self setNeedsLayout];
    
    CGRect endRect = CGRectMake(self.contentSize.width-1, self.contentSize.height-1, 1, 1);
    [self scrollRectToVisible:endRect animated:YES];
}

@end
