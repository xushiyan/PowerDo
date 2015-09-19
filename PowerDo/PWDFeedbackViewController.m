//
//  PWDFeedbackViewController.m
//  PowerDo
//
//  Created by Wang Jin on 13/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDFeedbackViewController.h"
#import "PWDFeedbackService.h"
#import "UIColor+Extras.h"

@interface PWDFeedbackViewController () <UITextFieldDelegate>

@property (nonatomic,strong) PWDFeedbackService *feedbackService;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PWDFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.feedbackService = [[PWDFeedbackService alloc] init];
    
    self.title = NSLocalizedString(@"Feedback", @"Feedback vc title");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_send"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UITextField *feedbackField = self.feedbackField;
    feedbackField.delegate = self;
    feedbackField.returnKeyType = UIReturnKeyNext;
    
    UITextField *emailField = self.emailField;
    emailField.delegate = self;
    emailField.returnKeyType = UIReturnKeyDone;
    
    self.scrollView.contentSize = [UIScreen mainScreen].bounds.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.feedbackField) {
        CGFloat scrollY = CGRectGetMinY(textField.frame) - 24;
        [self.scrollView setContentOffset:CGPointMake(0, scrollY) animated:YES];
    } else if (textField == self.emailField) {
        CGFloat scrollY = CGRectGetMinY(textField.frame) - 48;
        [self.scrollView setContentOffset:CGPointMake(0, scrollY) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.feedbackField) {
        [self.emailField becomeFirstResponder];
    } else if (textField == self.emailField) {
        [textField endEditing:YES];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)tapMoodButton:(UIButton *)sender {
    UIButton *happy = self.happyButton;
    UIButton *unhappy = self.unhappyButton;
    
    if (sender == happy) {
        self.feedbackService.mood = PWDFeedbackMoodHappy;
        happy.tintColor = [UIColor happyMoodColor];
        unhappy.tintColor = [UIColor lightGrayColor];
    } else if (sender == unhappy) {
        self.feedbackService.mood = PWDFeedbackMoodUnhappy;
        happy.tintColor = [UIColor lightGrayColor];
        unhappy.tintColor = [UIColor unhappyMoodColor];
    }
}

@end
