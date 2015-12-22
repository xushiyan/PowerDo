//
//  UIViewController+PowerKit.m
//  PowerKit
//
//  Created by XU SHIYAN on 6/12/15.
//  Copyright © 2015 PowerStudio. All rights reserved.
//

#import "UIViewController+PowerKit.h"

@implementation UIViewController (PowerKit)

- (void)presentNoMailAlert {
    UIAlertController *noMail = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unable to send mail", @"no mail alert title") message:NSLocalizedString(@"Please configure Apple Mail properly.", @"no mail alert message") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"no mail alert ok action") style:UIAlertActionStyleDefault
                                                          handler:nil];
    [noMail addAction:defaultAction];
    [self presentViewController:noMail animated:YES completion:nil];
}

- (void)presentAlertForCMError:(CMError)cmerror {
    NSString *title;
    NSString *message;
    switch (cmerror) {
        case CMErrorNULL:
            break;
        case CMErrorDeviceRequiresMovement:
            title = NSLocalizedString(@"The device must move for a sampling of motion data to occur.", @"");
            break;
        case CMErrorTrueNorthNotAvailable:
            title = NSLocalizedString(@"True north is not available on this device.", @"");
            message = NSLocalizedString(@"Probably location service is not turn on.", @"");
            break;
        case CMErrorUnknown:
            title = NSLocalizedString(@"An unknown error occurred.", @"");
            break;
        case CMErrorMotionActivityNotAvailable:
            title = NSLocalizedString(@"Motion activity support is not available on the current device.", @"");
            break;
        case CMErrorMotionActivityNotAuthorized:
            title = NSLocalizedString(@"Motion & Fitness is not authorized.", @"");
            message = NSLocalizedString(@"Please go to Settings > Privacy > Motion & Fitness to turn on the authorization for PowerLog.", @"");
            break;
        case CMErrorMotionActivityNotEntitled:
            title = NSLocalizedString(@"The app is missing a required entitlement.", @"");
            break;
        case CMErrorInvalidParameter:
            title = NSLocalizedString(@"An invalid parameter was specified.", @"");
            break;
        case CMErrorInvalidAction:
            title = NSLocalizedString(@"An invalid action occurred.", @"");
            break;
        case CMErrorNotAvailable:
            title = NSLocalizedString(@"Motion support is not available on the current device.", @"");
            break;
        case CMErrorNotEntitled:
            title = NSLocalizedString(@"The app is missing a required entitlement.", @"");
            break;
        case CMErrorNotAuthorized:
            title = NSLocalizedString(@"The app is not currently authorized to use motion support.", @"");
            break;
    }
    
    if (cmerror != CMErrorNULL) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"no mail alert ok action") style:UIAlertActionStyleDefault
                                                              handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
