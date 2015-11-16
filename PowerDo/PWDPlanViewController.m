//
//  PWDPlanViewController.m
//  PowerDo
//
//  Created by XU SHIYAN on 14/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDPlanViewController.h"
#import "PWDTask.h"

@interface PWDPlanViewController () <UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *tomorrowTasks;
@property (nonatomic,strong) NSMutableArray *somedayTasks;
@property (nonatomic,strong) NSArray *tasksList;

@property (nonatomic,weak) UITextField *addTaskField;

@end

NSString * const PWDPlanTaskCellIdentifier = @"PWDPlanTaskCellIdentifier";

@implementation PWDPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    
    self.tomorrowTasks = [NSMutableArray array];
    self.somedayTasks = [NSMutableArray array];
    self.tasksList = @[self.tomorrowTasks,self.somedayTasks];
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
    return [self.tasksList[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWDPlanTaskCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PWDPlanTaskCellIdentifier];
    }
    PWDTask *task = self.tasksList[indexPath.section][indexPath.row];
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
            NSMutableArray *tomorrowTasks = self.tomorrowTasks;
            UITableView *tableView = self.tableView;
            const PWDTask *task = [[PWDTask alloc] initWithTitle:taskTitle];
            const NSInteger index = 0;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
