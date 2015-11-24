//
//  PWDDetailViewController.m
//  PowerDo
//
//  Created by Xu, Raymond on 11/24/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDDetailViewController.h"
#import "UIColor+Extras.h"
#import "NSDate+PWDExtras.h"
#import "PWDConstants.h"

@interface PWDDetailViewController () <UITextViewDelegate>

@end

NSUInteger const PWDTaskTitleMaxCharCount = 200;

@implementation PWDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissFromPresentation:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissFromPresentation:)];
    
    UITextView *titleTextView = self.titleTextView;

    PWDTask *task = self.task;
    titleTextView.text = task.title;
    titleTextView.delegate = self;
    
    
    UISegmentedControl *difficultySelector = self.difficultySelector;
    difficultySelector.selectedSegmentIndex = task.difficulty - 1;
    difficultySelector.tintColor = [UIColor colorFromTaskDifficulty:task.difficulty];
    
    UISegmentedControl *dueDateGroupSelector = self.dueDateGroupSelector;
    dueDateGroupSelector.selectedSegmentIndex = task.dueDateGroup;
    
    self.messageLabel.text = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.titleTextView becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)dismissFromPresentation:(UIBarButtonItem *)sender {
    UITextView *titleTextView = self.titleTextView;
    [titleTextView endEditing:YES];

    if (sender == self.navigationItem.rightBarButtonItem) {
        PWDTask *task = self.task;
        task.title = titleTextView.text;
        task.difficulty = self.difficultySelector.selectedSegmentIndex + 1;
        switch (self.dueDateGroupSelector.selectedSegmentIndex) {
            case PWDTaskDueDateGroupToday: {
                task.dueDate = [NSDate dateOfTodayEnd];
                task.status = PWDTaskStatusOnGoing;
                [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayTasksManualChangeNotification object:nil];
            }
                break;
            case PWDTaskDueDateGroupTomorrow: {
                task.dueDate = [NSDate dateOfTomorrowEnd];
            }
                break;
            case PWDTaskDueDateGroupSomeDay: {
                task.dueDate = [NSDate distantFuture];
            }
                break;
        }
        [[PWDTaskManager sharedManager] saveContext];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleDifficultyChangeEvent:(UISegmentedControl *)sender {
    sender.tintColor = [UIColor colorFromTaskDifficulty:sender.selectedSegmentIndex + 1];
}

- (IBAction)handleDueDateGroupChangeEvent:(UISegmentedControl *)sender {
    PWDTaskDueDateGroup dueDateGroup = sender.selectedSegmentIndex;
    switch (dueDateGroup) {
        case PWDTaskDueDateGroupToday: {
            sender.tintColor = [UIColor redColor];
            self.messageLabel.text = NSLocalizedString(@"Adding task to today's plan will not increase your power score.", @"warning message when select today as due date");
            [self.messageLabel sizeToFit];
        }
            break;
        case PWDTaskDueDateGroupTomorrow: {
            sender.tintColor = [UIColor themeColor];
            self.messageLabel.text = nil;
        }
            break;
        case PWDTaskDueDateGroupSomeDay: {
            sender.tintColor = [UIColor themeColor];
            self.messageLabel.text = nil;
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    return [textView endEditing:YES];
}

@end
