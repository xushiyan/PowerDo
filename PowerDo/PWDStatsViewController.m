//
//  PWDStatsViewController.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/12/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

@import CoreData;
#import "PWDStatsViewController.h"
#import "PWDConstants.h"
#import "PWDDailyRecord.h"
#import "PWDTaskManager.h"

@interface PWDStatsViewController () <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,weak) UIView *chartView;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong,readonly) NSDateFormatter *dateFormatter;

@end

NSString * const PWDStatsTableCellIdentifier = @"PWDStatsTableCellIdentifier";

@implementation PWDStatsViewController

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:tableView];
    self.view = view;
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(tableView);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:viewDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView]|" options:0 metrics:nil views:viewDict]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:tableView attribute:NSLayoutAttributeHeight
                                                    multiplier:kPWDGoldenRatio constant:0]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    
    NSManagedObjectContext *context = taskManager.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [taskManager.managedObjectModel entitiesByName][NSStringFromClass([PWDDailyRecord class])];
    fetchRequest.entity = entityDescription;
    NSString *sortKey = NSStringFromSelector(@selector(dateRaw));
#ifdef DEBUG
    sortKey = NSStringFromSelector(@selector(createDateRaw));
#endif
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
    NSArray *sortDescriptors = @[sort1];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if (!success) {
        NSLog(@"fetchedResultsController error: %@", error);
        abort();
    }
    controller.delegate = self;
    self.fetchedResultsController = controller;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Functions
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PWDDailyRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *recordDate = record.date;
#ifdef DEBUG
    recordDate = [NSDate dateWithTimeIntervalSince1970:record.createDateRaw];
#endif
    cell.textLabel.text = [self.dateFormatter stringFromDate:recordDate];
    UILabel *powerLabel = [UILabel new];
    powerLabel.text = record.powerText;
    [powerLabel sizeToFit];
    cell.accessoryView = powerLabel;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWDStatsTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PWDStatsTableCellIdentifier];
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

#pragma mark - 
@synthesize dateFormatter = _dateFormatter;
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
#ifdef DEBUG
        _dateFormatter.timeStyle = NSDateFormatterMediumStyle;
#endif

    }
    return _dateFormatter;
}
@end
