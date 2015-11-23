//
//  PWDTodayPowerBar.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/23/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTodayPowerBar.h"
#import "UIColor+Extras.h"

@implementation PWDTodayPowerBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (!_todayRecord || !_todayRecord.tasks.count) {
        return;
    }
    
    CGSize size = rect.size;
    CGFloat baseLength = 10.0f;
    CGFloat barY = 44.0f;
    CGFloat barWidth = 40.0f;
    CGFloat barEndMargin = 64.0f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint start = CGPointMake(0, barY);
    CGPoint end;
    [path moveToPoint:start];
    CGFloat maxLength = size.width - barEndMargin;
    CGFloat ptPerPower = .0f;
    ptPerPower = (maxLength - baseLength)/100;
    end = CGPointMake(baseLength + ptPerPower*_todayRecord.power, barY);
    [path addLineToPoint:end];
    
    [path setLineWidth:barWidth];
    [[UIColor themeColor] setStroke];
    [path stroke];
    
    CGRect textRect = CGRectMake(end.x, end.y-12.0f, barEndMargin, barWidth);
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    [_todayRecord.powerText drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                 NSParagraphStyleAttributeName:paragraph
                                                                 }];
}

- (void)setTodayRecord:(PWDDailyRecord *)todayRecord {
    _todayRecord = todayRecord;
    [self setNeedsDisplay];
}

@end
