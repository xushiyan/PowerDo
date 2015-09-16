//
//  PWDFeedbackViewController.h
//  PowerDo
//
//  Created by Wang Jin on 13/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDFeedbackTextField.h"

@interface PWDFeedbackViewController : UIViewController

@property (weak, nonatomic) IBOutlet PWDFeedbackTextField *feedbackField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *happyButton;
@property (weak, nonatomic) IBOutlet UIButton *unhappyButton;

@end
