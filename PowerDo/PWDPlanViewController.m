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

@interface PWDPlanViewController () <UITextFieldDelegate> {
    CGFloat _headerHeight;
}
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,weak) UITextField *addTaskField;

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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dueDateGroup != 0"];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptorPrimary = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(dueDateGroup)) ascending:YES];
    NSSortDescriptor *sortDescriptorSecondary = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(createDateRaw)) ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptorPrimary,sortDescriptorSecondary];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:@"dueDateGroupText"
                                                                                            cacheName:nil];
    
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if (!success) {
        NSLog(@"fetchedResultsController error: %@", error);
        abort();
    }
    controller.delegate = self;
    self.fetchedResultsController = controller;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // TODO: remove simulate time change action
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startAddingNewTask:)],
//                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(simulateTimeChange:)]
                                                ];
    
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignificantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];
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

- (void)startAddingNewTask:(id)sender {
    UITableView *tableView = self.tableView;
    [self animateScrollView:tableView forContentInsetsTop:_headerHeight];
    [self.addTaskField becomeFirstResponder];
}
/*
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
*/
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
    [UIView animateWithDuration:0.25 animations:^{
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
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.addTaskField) {
        UITableView *tableView = self.tableView;
        NSString *taskTitle = textField.text;
        if (taskTitle.length) {
            PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
            NSEntityDescription *entityDescription = [taskManager.managedObjectModel entitiesByName][NSStringFromClass([PWDTask class])];
            PWDTask *task = [[PWDTask alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:taskManager.managedObjectContext];
            task.title = taskTitle;
//            task.dueDate = [NSDate date]; // TODO: remove
            textField.text = nil;
            [taskManager saveContext];
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

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PWDTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];

    NSArray *actions;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                      title:NSLocalizedString(@"Delete", @"Delete action title")
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        [taskManager.managedObjectContext deleteObject:task];
                                                                        [taskManager saveContext];
                                                                    }];
    UITableViewRowAction *dueSomeday = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:NSLocalizedString(@"Due Someday", @"Due Someday action title")
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        task.dueDate = [NSDate distantFuture];
                                                                        [taskManager saveContext];
                                                                    }];
    UITableViewRowAction *dueTomorrow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:NSLocalizedString(@"Due Tomorrow", @"Due Someday action title")
                                                                        handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                            task.dueDate = [NSDate dateOfTomorrowEnd];
                                                                            [taskManager saveContext];
                                                                        }];
    
    switch (task.dueDateGroup) {
        case PWDTaskDueDateGroupTomorrow: {
            actions = @[delete,dueSomeday];
        }
            break;
            
        case PWDTaskDueDateGroupSomeDay: {
            actions = @[delete,dueTomorrow];
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
    return NO;
}

@end
