//
//  PWDSettingsViewController.m
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDSettingsViewController.h"
#import "PWDDatePickerCell.h"
#import "PWDConstants.h"

@implementation PWDSettingsViewController {
    BOOL _datePickerOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *cutoffTime = [userDefaults objectForKey:PWDUserDefaultsKeyPlanCutoffTime];
    if (!cutoffTime) {
        
    }
    
    UITableView *tableView = self.tableView;
    tableView.estimatedRowHeight = 44;
    [PWDTableViewCell registerClassForTableView:tableView];
    [PWDDatePickerCell registerNibForTableView:tableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case PWDSettingsSectionConfigure:
            switch (row) {
                case PWDConfigureRowPlanCutoffTime: {
                    _datePickerOpen = !_datePickerOpen;
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:PWDSettingsSectionConfigure] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                    break;
            }
            break;
    }
}

- (BOOL)tableView:(nonnull UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BOOL highlight = YES;
    switch (section) {
        case PWDSettingsSectionConfigure:
            switch (row) {
                case PWDConfigureRowPlanCutoffTimePicker: {
                    highlight = NO;
                }
                    break;
            }
            break;
    }
    return highlight;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    CGFloat height = UITableViewAutomaticDimension;
    switch (section) {
        case PWDSettingsSectionConfigure:
            switch (row) {
                case PWDConfigureRowPlanCutoffTimePicker: {
                    if (!_datePickerOpen) {
                        height = 0;
                    }
                }
                    break;
            }
            break;
    }
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return PWDSettingsSectionEnd;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    switch (section) {
        case PWDSettingsSectionConfigure: {
            num = PWDConfigureRowEnd;
        }
            break;
        case PWDSettingsSectionFeedback: {
            num = PWDFeedbackRowEnd;
        }
            break;
    }
    return num;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *xCell = nil;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case PWDSettingsSectionConfigure: {
            switch (row) {
                case PWDConfigureRowPlanCutoffTime: {
                    xCell = [tableView dequeueReusableCellWithIdentifier:[PWDTableViewCell identifier] forIndexPath:indexPath];
                    xCell.textLabel.text = NSLocalizedString(@"Cutoff Time", @"Settings cell label");
                }
                    break;
                case PWDConfigureRowPlanCutoffTimePicker: {
                    PWDDatePickerCell *cell = (PWDDatePickerCell *)[tableView dequeueReusableCellWithIdentifier:[PWDDatePickerCell identifier] forIndexPath:indexPath];
                    
                    xCell = cell;
                }
                    break;
            }
        }
            break;
        case PWDSettingsSectionFeedback: {
            xCell = [tableView dequeueReusableCellWithIdentifier:[PWDTableViewCell identifier] forIndexPath:indexPath];
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    xCell.textLabel.text = NSLocalizedString(@"Feedback", @"Settings cell label");
                    xCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case PWDFeedbackRowLike: {
                    xCell.textLabel.text = NSLocalizedString(@"Like us!", @"Settings cell label");
                    xCell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case PWDFeedbackRowAbout: {
                    xCell.textLabel.text = NSLocalizedString(@"About", @"Settings cell label");
                    xCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
            }
        }
            break;
    }
    return xCell;
}

@end
