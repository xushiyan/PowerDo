//
//  PWDChartView.h
//  PowerDo
//
//  Created by Xu, Raymond on 11/22/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDDailyRecord.h"

@interface PWDChartView : UIView

@property (nonatomic,copy) NSArray * _Nullable records;
@property (nonatomic) BOOL showTrendLine;

- (CGFloat)updateRecords:(NSArray <PWDDailyRecord *> * _Nullable)records;
- (CGRect)viewingRectForRecord:(PWDDailyRecord * _Nonnull)record;

@end
