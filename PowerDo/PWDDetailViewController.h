//
//  PWDDetailViewController.h
//  PowerDo
//
//  Created by Xu, Raymond on 11/24/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDTask.h"
#import "PWDTaskManager.h"

@interface PWDDetailViewController : UIViewController

@property (nonatomic,strong) PWDTask *task;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dueDateGroupSelector;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
