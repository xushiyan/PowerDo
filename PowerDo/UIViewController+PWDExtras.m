//
//  UIViewController+PWLExtras.m
//  PowerLog
//
//  Created by XU SHIYAN on 25/10/15.
//  Copyright © 2015 XU SHIYAN. All rights reserved.
//

#import "UIViewController+PWDExtras.h"

@implementation UIViewController (PWDExtras)

- (void)presentNoMailAlert {
    UIAlertController *noMail = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unable to send mail", @"no mail alert title") message:NSLocalizedString(@"Please configure Apple Mail properly.", @"no mail alert message") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"no mail alert ok action") style:UIAlertActionStyleDefault
                                                          handler:nil];
    [noMail addAction:defaultAction];
    [self presentViewController:noMail animated:YES completion:nil];
}

@end
