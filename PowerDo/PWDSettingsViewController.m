//
//  PWDSettingsViewController.m
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDSettingsViewController.h"

static NSString * const SettingsCellIdentifier = @"SettingsCellIdentifier";

@implementation PWDSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", @"Settings tab title");
    
    UITableView *tableView = self.tableView;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return PWDSettingsSectionEnd;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    switch (section) {
        case PWDSettingsSectionTime:
            num = 1;
            break;
        case PWDSettingsSectionFeedback: {
            num = PWDFeedbackRowEnd;
        }
            break;
    }
    return num;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case PWDSettingsSectionTime: {
            cell.textLabel.text = NSLocalizedString(@"Configure Time", @"Settings cell label");
        }
            break;
        case PWDSettingsSectionFeedback: {
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    cell.textLabel.text = NSLocalizedString(@"Feedback", @"Settings cell label");
                }
                    break;
                case PWDFeedbackRowLike: {
                    cell.textLabel.text = NSLocalizedString(@"Like us!", @"Settings cell label");
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case PWDFeedbackRowAbout: {
                    cell.textLabel.text = NSLocalizedString(@"About", @"Settings cell label");
                }
                    break;
            }
        }
            break;
    }
    return cell;
}

@end
