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
#import "FoundationExtras.h"
#import "PWDTaskManager.h"

@implementation PWDSettingsViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        case PWDSettingsSectionFeedback:
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    
                }
                    break;
                case PWDFeedbackRowAbout: {
                    
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
        case PWDSettingsSectionFeedback:
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    
                }
                    break;
                case PWDFeedbackRowAbout: {
                    
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
        case PWDSettingsSectionFeedback:
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    
                }
                    break;
                case PWDFeedbackRowAbout: {
                    
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
        case PWDSettingsSectionFeedback: {
            xCell = [tableView dequeueReusableCellWithIdentifier:[PWDTableViewCell identifier] forIndexPath:indexPath];
            xCell.accessoryView = nil;
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    xCell.textLabel.text = NSLocalizedString(@"Feedback", @"Settings cell label");
                    xCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

#pragma mark - Actions


@end
