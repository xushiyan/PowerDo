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
    
    // TODO: remove left item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(simulateTimeChange:)];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignificantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Functions
// TODO: remove this function
- (void)simulateTimeChange:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationSignificantTimeChangeNotification object:nil];
}

- (void)handleSignificantTimeChange:(NSNotification *)note {
    NSMutableArray *tomorrowTasks = self.taskLists[PWDPlanSectionTomorrow];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [tomorrowTasks enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([calendar isDateInToday:task.dueDate]) {
            [indexSet addIndex:idx];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:PWDPlanSectionTomorrow];
            [indexPaths addObject:indexPath];
        }
    }];
    [tomorrowTasks removeObjectsAtIndexes:indexSet];
    __weak UITableView *tableView = self.tableView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    });

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
//            task.dueDate = [NSDate date]; // TODO: remove
            [tomorrowTasks insertObject:task atIndex:index];
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:PWDPlanSectionTomorrow]]
                                  withRowAnimation:UITableViewRowAnimationFade];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
