//
//  PWDChartScrollView.h
//  PowerDo
//
//  Created by Xu, Raymond on 11/22/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDDailyRecord.h"

@interface PWDChartScrollView : UIScrollView

- (void)updateChartWithRecords:(NSArray <PWDDailyRecord *> * _Nullable)records;

@end
