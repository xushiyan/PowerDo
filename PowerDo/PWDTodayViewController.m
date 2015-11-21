//
//  PWDTodayViewController.m
//  PowerDo
//
//  Created by Wang Jin on 7/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTodayViewController.h"
#import "PWDTask.h"
#import "PWDTaskManager.h"
#import "PWDTaskDifficultyIndicator.h"
#import "PWDConstants.h"
#import "NSDate+PWDExtras.h"
#import "UIColor+Extras.h"

@interface PWDTodayViewController ()

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

NSString * const PWDTodayTaskCellIdentifier = @"PWDTodayTaskCellIdentifier";

@implementation PWDTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    
    NSManagedObjectContext *context = taskManager.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [taskManager.managedObjectModel entitiesByName][NSStringFromClass([PWDTask class])];
    fetchRequest.entity = entityDescription;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dueDateGroup == %ld", PWDTaskDueDateGroupToday];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptorPrimary = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(status)) ascending:YES];
    NSSortDescriptor *sortDescriptorSecondary = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(createDateRaw)) ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptorPrimary,sortDescriptorSecondary];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:NSStringFromSelector(@selector(statusText))
                                                                                            cacheName:nil];
    
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if (!success) {
        NSLog(@"fetchedResultsController error: %@", error);
        abort();
    }
    controller.delegate = self;
    self.fetchedResultsController = controller;
    
    
    UITableView *tableView = self.tableView;
    tableView.rowHeight = 44;
    tableView.estimatedRowHeight = 44;
    UILabel *powerValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    powerValue.text = [NSString stringWithFormat:@"Power %.2lf", .0f];
    powerValue.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    powerValue.textAlignment = NSTextAlignmentCenter;
    powerValue.textColor = [UIColor themeColor];
    tableView.tableHeaderView = powerValue;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Functions
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PWDTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber *strikeThrough = task.status == PWDTaskStatusCompleted ? @(NSUnderlineStyleSingle) : @(NSUnderlineStyleNone);
    UIColor *completeColor = task.status == PWDTaskStatusCompleted ? [UIColor lightGrayColor] : [UIColor blackColor];
    NSAttributedString *taskTitle = [[NSAttributedString alloc] initWithString:task.title attributes:@{NSStrikethroughStyleAttributeName:strikeThrough,
                                                                                                       NSForegroundColorAttributeName:completeColor}];
    cell.textLabel.attributedText = taskTitle;
    PWDTaskDifficultyIndicator *difficultyView = [[PWDTaskDifficultyIndicator alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
    difficultyView.backgroundColor = [UIColor clearColor];
    difficultyView.difficulty = task.difficulty;
    cell.accessoryView = difficultyView;
}
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PWDTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    
    NSArray *actions;
    UITableViewRowAction *done = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                        title:NSLocalizedString(@"Done", @"Complete action title")
                                                                      handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                          task.status = PWDTaskStatusCompleted;
                                                                          [taskManager saveContext];
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
                                                                      }];
    done.backgroundColor = [UIColor themeColor];
    UITableViewRowAction *redo = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:NSLocalizedString(@"Redo", @"Redo action title")
                                                                        handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                            task.status = PWDTaskStatusOnGoing;
                                                                            [taskManager saveContext];
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
                                                                        }];
    redo.backgroundColor = [UIColor flatOrangeColor];
    UITableViewRowAction *later = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                           title:NSLocalizedString(@"Later", @"postpone action title")
                                                                         handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             task.dueDate = [NSDate distantFuture];
                                                                             task.status = PWDTaskStatusInPlan;
                                                                             [taskManager saveContext];
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
                                                                         }];
    
    switch (task.status) {
        case PWDTaskStatusOnGoing: {
            actions = @[done,later];
        }
            break;
            
        case PWDTaskStatusCompleted: {
            actions = @[redo,later];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWDTodayTaskCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PWDTodayTaskCellIdentifier];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];
}

@end
