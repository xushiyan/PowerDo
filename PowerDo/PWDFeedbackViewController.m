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

@interface PWDFeedbackViewController ()

@property (nonatomic,strong) PWDFeedbackService *feedbackService;

@end

@implementation PWDFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.feedbackService = [[PWDFeedbackService alloc] init];
    
    self.title = NSLocalizedString(@"Feedback", @"Feedback vc title");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_send"] style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
