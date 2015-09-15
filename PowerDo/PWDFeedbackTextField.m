//
//  PWDFeedbackTextField.m
//  PowerDo
//
//  Created by Wang Jin on 15/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDFeedbackTextField.h"

@implementation PWDFeedbackTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 40);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 40);
}

@end
