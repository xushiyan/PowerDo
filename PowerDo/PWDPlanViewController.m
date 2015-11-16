//
//  PWDPlanViewController.m
//  PowerDo
//
//  Created by XU SHIYAN on 14/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDPlanViewController.h"
#import "PWDTask.h"
#import "NSDate+PWDExtras.h"

@interface PWDPlanViewController () <UITextFieldDelegate>

@property (nonatomic,strong) NSArray *taskLists;
@property (nonatomic,weak) UITextField *addTaskField;

@end

NSString * const PWDPlanTaskCellIdentifier = @"PWDPlanTaskCellIdentifier";

@implementation PWDPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITextField *addTaskField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    addTaskField.returnKeyType = UIReturnKeyDone;
    addTaskField.placeholder = NSLocalizedString(@"What to do tomorrow?", @"add task field placeholder");
    addTaskField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    addTaskField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    addTaskField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTaskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addTaskField.textAlignment = NSTextAlignmentCenter;
    addTaskField.delegate = self;
    self.addTaskField = addTaskField;
    
    UITableView *tableView = self.tableView;
    tableView.tableHeaderView = addTaskField;
    


    self.taskLists = @[[NSMutableArray array],[NSMutableArray array]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PWDPlanSectionEnd;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.taskLists[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWDPlanTaskCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PWDPlanTaskCellIdentifier];
    }
    PWDTask *task = self.taskLists[indexPath.section][indexPath.row];
    cell.textLabel.text = task.title;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case PWDPlanSectionTomorrow:
            title = NSLocalizedString(@"Tomorrow", @"tomorrow section title");
            break;
        case PWDPlanSectionSomeday:
            title = NSLocalizedString(@"Someday", @"someday section title");
            break;
    }
    return title;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.addTaskField) {
        NSString *taskTitle = textField.text;
        if (taskTitle.length) {
            NSMutableArray *tomorrowTasks = self.taskLists[PWDPlanSectionTomorrow];
            UITableView *tableView = self.tableView;
            const PWDTask *task = [[PWDTask alloc] initWithTitle:taskTitle];
            const NSInteger index = 0;
            [tomorrowTasks insertObject:task atIndex:index];
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:PWDPlanSectionTomorrow]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            textField.text = nil;
        }
        return [textField endEditing:YES];
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *taskList = self.taskLists[indexPath.section];
        [taskList removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *fromTaskList = self.taskLists[fromIndexPath.section];
    PWDTask *movingTask = fromTaskList[fromIndexPath.row];
    NSMutableArray *toTaskList = self.taskLists[toIndexPath.section];
    [toTaskList insertObject:movingTask atIndex:toIndexPath.row];
    [fromTaskList removeObjectAtIndex:fromIndexPath.row];
    if (fromIndexPath.section == PWDPlanSectionTomorrow && toIndexPath.section == PWDPlanSectionSomeday) {
        movingTask.dueDate = [NSDate distantFuture];
    } else if (fromIndexPath.section == PWDPlanSectionSomeday && toIndexPath.section == PWDPlanSectionTomorrow) {
        movingTask.dueDate = [NSDate dateOfTomorrowEnd];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end
