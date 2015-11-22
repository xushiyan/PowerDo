//
//  PWDSettingsViewController.m
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDSettingsViewController.h"
#import "PWDConstants.h"
#import "PWDTaskManager.h"
#import "PWDFeedbackViewController.h"
#import "PWDHelpViewController.h"
#import "UITableViewCell+PWDExtras.h"

NSString * const PWLSettingsCellIdentifier = @"PWLSettingsCellIdentifier";

@implementation PWDSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    UITableView *tableView = self.tableView;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    [UITableViewCell registerClassForTableView:tableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case PWDSettingsSectionHelp: {
            PWDHelpViewController *help_vc = [[PWDHelpViewController alloc] initWithNibName:NSStringFromClass([PWDHelpViewController class]) bundle:nil];
            [self showViewController:help_vc sender:nil];
        }
            break;
        case PWDSettingsSectionFeedback:
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    PWDFeedbackViewController *feedback_vc = [[PWDFeedbackViewController alloc] initWithNibName:NSStringFromClass([PWDFeedbackViewController class]) bundle:nil];
                    [self showViewController:feedback_vc sender:nil];
                }
                    break;
                case PWDFeedbackRowRateIt: {
                    NSURL *appStoreURL = [NSURL URLWithString:@"itms-apps://itunes.com/apps/PowerDo"];
                    [[UIApplication sharedApplication] openURL:appStoreURL];
                }
                    break;
            }
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return PWDSettingsSectionEnd;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    switch (section) {
        case PWDSettingsSectionHelp: {
            num = 1;
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
    UITableViewCell *xCell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier] forIndexPath:indexPath];;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case PWDSettingsSectionHelp: {
            xCell.textLabel.text = NSLocalizedString(@"How to gain Power?", @"Settings cell label");
            xCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case PWDSettingsSectionFeedback: {
            xCell.accessoryView = nil;
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    xCell.textLabel.text = NSLocalizedString(@"Feedback", @"Settings cell label");
                    xCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case PWDFeedbackRowRateIt: {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    xCell.textLabel.text = NSLocalizedString(@"Rate It", @"Settings cell label");
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
