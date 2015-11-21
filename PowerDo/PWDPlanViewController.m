//
//  PWDPlanViewController.m
//  PowerDo
//
//  Created by XU SHIYAN on 14/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDPlanViewController.h"
#import "PWDTaskManager.h"
#import "PWDTask.h"
#import "NSDate+PWDExtras.h"
#import "PWDTaskDifficultyIndicator.h"
#import "PWDConstants.h"

@interface PWDPlanViewController () <UITextFieldDelegate> {
    CGFloat _headerHeight;
}
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,weak) UITextField *addTaskField;

@property (nonatomic,strong) UIBarButtonItem *editButton;
@property (nonatomic,strong) UIBarButtonItem *addButton;
@property (nonatomic,strong) UIBarButtonItem *deleteButton;
@property (nonatomic,strong) UIBarButtonItem *cancelButton;

@end

NSString * const PWDPlanTaskCellIdentifier = @"PWDPlanTaskCellIdentifier";

@implementation PWDPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    
    NSManagedObjectContext *context = taskManager.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [taskManager.managedObjectModel entitiesByName][NSStringFromClass([PWDTask class])];
    fetchRequest.entity = entityDescription;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %ld", NSStringFromSelector(@selector(dueDateGroup)),PWDTaskDueDateGroupToday];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptorPrimary = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(dueDateGroup)) ascending:YES];
    NSSortDescriptor *sortDescriptorSecondary = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(createDateRaw)) ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptorPrimary,sortDescriptorSecondary];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:NSStringFromSelector(@selector(dueDateGroupText))
                                                                                            cacheName:nil];
    
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if (!success) {
        NSLog(@"fetchedResultsController error: %@", error);
        abort();
    }
    controller.delegate = self;
    self.fetchedResultsController = controller;
    
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete All", @"Delete all button title") style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    
    self.navigationItem.leftBarButtonItem = editButton;
#ifdef DEBUG
    UIBarButtonItem *simulateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(simulateSignificantTimeChange:)];
    self.navigationItem.rightBarButtonItems = @[addButton,simulateButton];
#else
    self.navigationItem.rightBarButtonItem = addButton;
#endif

    self.editButton = editButton;
    self.addButton = addButton;
    self.deleteButton = deleteButton;
    self.cancelButton = cancelButton;
    
    _headerHeight = 64;
    UITextField *addTaskField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, _headerHeight)];
    addTaskField.returnKeyType = UIReturnKeyDone;
    addTaskField.placeholder = NSLocalizedString(@"What to do tomorrow?", @"add task field placeholder");
    addTaskField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    addTaskField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    addTaskField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTaskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addTaskField.textAlignment = NSTextAlignmentCenter;
    addTaskField.delegate = self;
    self.addTaskField = addTaskField;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = self.tableView;
    tableView.tableHeaderView = addTaskField;
    tableView.rowHeight = 44;
    tableView.estimatedRowHeight = 44;
    tableView.allowsSelectionDuringEditing = YES;
    tableView.allowsMultipleSelectionDuringEditing = YES;

    [self updateBarButtonItems];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action methods
#ifdef DEBUG
- (void)simulateSignificantTimeChange:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationSignificantTimeChangeNotification object:nil];
}
#endif

- (void)editAction:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    [self updateBarButtonItems];
}

- (void)cancelAction:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    [self updateBarButtonItems];
}

- (void)addAction:(id)sender {
    UITableView *tableView = self.tableView;
    [self animateScrollView:tableView forContentInsetsTop:_headerHeight];
    [self.addTaskField becomeFirstResponder];
}

- (void)deleteAction:(id)sender {
    NSFetchedResultsController *controller = self.fetchedResultsController;
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    if (selectedRows.count == 0) {
        [controller.fetchedObjects enumerateObjectsUsingBlock:^(PWDTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [taskManager.managedObjectContext deleteObject:task];
        }];
    } else {
        [selectedRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            PWDTask *task = [controller objectAtIndexPath:indexPath];
            [taskManager.managedObjectContext deleteObject:task];
        }];
    }
    [taskManager saveContext];
    
    [self.tableView setEditing:NO animated:YES];
    [self updateBarButtonItems];
}

#pragma mark - Functions
- (void)updateBarButtonItems {
    if (self.tableView.isEditing) {
        self.navigationItem.leftBarButtonItem = self.cancelButton;
        [self updateDeleteButtonTitle];
        self.navigationItem.rightBarButtonItem = self.deleteButton;
    } else {
        self.editButton.enabled = self.fetchedResultsController.fetchedObjects.count > 0;
        self.navigationItem.leftBarButtonItem = self.editButton;
        self.navigationItem.rightBarButtonItem = self.addButton;
    }
}

- (void)updateDeleteButtonTitle {
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.fetchedResultsController.fetchedObjects.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected) {
        self.deleteButton.title = NSLocalizedString(@"Delete All", @"Delete all button title");
    } else {
        NSString *titleFormatString =
        NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
        self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PWDTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.title;
    PWDTaskDifficultyIndicator *difficultyView = [[PWDTaskDifficultyIndicator alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
    difficultyView.backgroundColor = [UIColor clearColor];
    difficultyView.difficulty = task.difficulty;
    cell.accessoryView = difficultyView;
}

- (void)animateScrollView:(UIScrollView *)scrollView forContentInsetsTop:(CGFloat)top {
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top = top;
    [UIView animateWithDuration:0.25f animations:^{
        scrollView.contentInset = insets;
        scrollView.scrollIndicatorInsets = insets;
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = -scrollView.contentOffset.y;
    CGFloat top = scrollView.contentInset.top;
    if (top == _headerHeight) {
        if (yOffset < _headerHeight/2) {
            [self animateScrollView:scrollView forContentInsetsTop:0];
            [self.addTaskField resignFirstResponder];
        }
    } else if (top == 0) {
        if (yOffset > _headerHeight/2) {
            [self animateScrollView:scrollView forContentInsetsTop:_headerHeight];
            [self.addTaskField becomeFirstResponder];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWDPlanTaskCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PWDPlanTaskCellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self updateBarButtonItems];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.addTaskField) {
        UITableView *tableView = self.tableView;
        NSString *taskTitle = textField.text;
        if (taskTitle.length) {
            PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
            PWDTask *task = [taskManager insertNewTaskForTomorrowWithTitle:taskTitle inContext:taskManager.managedObjectContext];
            if (task) {
                textField.text = nil;
            }
            return NO;
        } else {
            [self animateScrollView:tableView forContentInsetsTop:0];
            return [textField endEditing:YES];
        }
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        [self updateDeleteButtonTitle];

    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PWDTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSInteger difficulty = task.difficulty;
        difficulty++;
        if (difficulty > PWDTaskDifficultyHard) {
            difficulty -= PWDTaskDifficultyHard;
        }
        task.difficulty = difficulty;
        [[PWDTaskManager sharedManager] saveContext];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        [self updateDeleteButtonTitle];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PWDTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];

    NSArray *actions;
    UITableViewRowAction *dueToday = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                      title:NSLocalizedString(@"Today", @"Due Today action title")
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        task.dueDate = [NSDate dateOfTodayEnd];
                                                                        task.status = PWDTaskStatusOnGoing;
                                                                        [taskManager saveContext];
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
                                                                    }];
    UITableViewRowAction *dueSomeday = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:NSLocalizedString(@"Someday", @"Due Someday action title")
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        task.dueDate = [NSDate distantFuture];
                                                                        [taskManager saveContext];
                                                                    }];
    UITableViewRowAction *dueTomorrow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:NSLocalizedString(@"Tomorrow", @"Due Someday action title")
                                                                        handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                            task.dueDate = [NSDate dateOfTomorrowEnd];
                                                                            [taskManager saveContext];
                                                                        }];
    
    switch (task.dueDateGroup) {
        case PWDTaskDueDateGroupTomorrow: {
            actions = @[dueToday,dueSomeday];
        }
            break;
            
        case PWDTaskDueDateGroupSomeDay: {
            actions = @[dueToday,dueTomorrow];
        }
            break;
            
        default:
            break;
    }
    return actions;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
