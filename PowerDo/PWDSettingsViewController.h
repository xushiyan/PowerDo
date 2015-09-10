//
//  PWDSettingsViewController.h
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PWDSettingsSection {
    PWDSettingsSectionTime,
    PWDSettingsSectionFeedback,
    PWDSettingsSectionEnd
};

enum PWDFeedbackRow {
    PWDFeedbackRowFeedback,
    PWDFeedbackRowLike,
    PWDFeedbackRowAbout,
    PWDFeedbackRowEnd
};

@interface PWDSettingsViewController : UITableViewController

@end
