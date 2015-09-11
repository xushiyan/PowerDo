//
//  PWDSettingsViewController.h
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PWDSettingsSection) {
    PWDSettingsSectionConfigure,
    PWDSettingsSectionFeedback,
    PWDSettingsSectionEnd
};

typedef NS_ENUM(NSInteger, PWDConfigureRow) {
    PWDConfigureRowPlanCutoffTime,
    PWDConfigureRowPlanCutoffTimePicker,
    PWDConfigureRowEnd
};

typedef NS_ENUM(NSInteger, PWDFeedbackRow) {
    PWDFeedbackRowFeedback,
    PWDFeedbackRowLike,
    PWDFeedbackRowAbout,
    PWDFeedbackRowEnd
};

@interface PWDSettingsViewController : UITableViewController

@end
