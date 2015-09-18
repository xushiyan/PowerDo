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
    feedbackField.returnKeyType = UIReturnKeyDone;
    
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
    [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textField.frame)) animated:YES];
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
