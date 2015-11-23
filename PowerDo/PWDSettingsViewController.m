//
//  PWDSettingsViewController.m
//  PowerDo
//
//  Created by Wang Jin on 9/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

@import MessageUI;
#import "PWDSettingsViewController.h"
#import "PWDConstants.h"
#import "PWDTaskManager.h"
#import "PWDFeedbackViewController.h"
#import "UITableViewCell+PWDExtras.h"
#import "UIViewController+PWDExtras.h"

NSString * const PWLSettingsCellIdentifier = @"PWLSettingsCellIdentifier";

@interface PWDSettingsViewController () <MFMailComposeViewControllerDelegate>

@end

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
        case PWDSettingsSectionFeedback:
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    if ([MFMailComposeViewController canSendMail]) {
                        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                        mail.mailComposeDelegate = self;
                        [mail setToRecipients:@[@"feedback-powerlog@outlook.com"]];
                        [mail setSubject:NSLocalizedString(@"Feedback for PowerDo", @"Email subject for feedback.")];
                        
                        NSBundle *bundle = [NSBundle mainBundle];
                        UIDevice *device = [UIDevice currentDevice];
                        NSLocale *locale = [NSLocale currentLocale];
                        UIScreen *screen = [UIScreen mainScreen];
                        NSMutableString *body = [NSMutableString stringWithString:NSLocalizedString(@"Hi\n\nI would like to provide the following feedback.\n\n\n\n\n", @"Feedback email body")];
                        [body appendFormat:@"%@: %@ build %@\n", NSLocalizedString(@"App version", @""), [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [bundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
                        [body appendFormat:@"%@: %@ %@\n", NSLocalizedString(@"OS version", @""),[device systemName], [device systemVersion]];
                        [body appendFormat:@"%@: %@\n", NSLocalizedString(@"Device", @""), [device localizedModel]];
                        [body appendFormat:@"%@: %@\n", NSLocalizedString(@"Device locale", @""), [locale localeIdentifier]];
                        [body appendFormat:@"%@: %@\n", NSLocalizedString(@"App locale", @""), [[bundle preferredLocalizations] firstObject]];
                        [body appendFormat:@"%@: %@\n", NSLocalizedString(@"Screen Size", @""), NSStringFromCGRect(screen.bounds)];
                        [body appendFormat:@"%@: %.1lf\n", NSLocalizedString(@"Screen Scale", @""), screen.scale];
                        [mail setMessageBody:body isHTML:NO];
                        
                        [self presentViewController:mail animated:YES completion:NULL];
                    } else {
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        [self presentNoMailAlert];
                    }
                }
                    break;
                case PWDFeedbackRowRateIt: {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        case PWDSettingsSectionFeedback: {
            xCell.accessoryView = nil;
            switch (row) {
                case PWDFeedbackRowFeedback: {
                    xCell.textLabel.text = NSLocalizedString(@"Feedback", @"Settings cell label");
                    xCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case PWDFeedbackRowRateIt: {
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

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
