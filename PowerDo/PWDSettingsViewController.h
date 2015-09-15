//
//  PWDSettingsViewController.h
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PWDSettingsSection) {
    PWDSettingsSectionFeedback,
    PWDSettingsSectionEnd
};

typedef NS_ENUM(NSInteger, PWDFeedbackRow) {
    PWDFeedbackRowHelp,
    PWDFeedbackRowFeedback,
    PWDFeedbackRowAbout,
    PWDFeedbackRowEnd
};

@interface PWDSettingsViewController : UITableViewController

@end
