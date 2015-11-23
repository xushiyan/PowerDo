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
#import "PWDChartScrollView.h"
#import "UIColor+Extras.h"

@interface PWDStatsViewController () <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate> {
    CGFloat _headerHeight;
    NSIndexPath *_lastSelectedIndexPath;
}

@property (nonatomic,weak) PWDChartScrollView *chartScrollView;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) UIButton *expandButton;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong,readonly) NSDateFormatter *dateFormatter;

@property (nonatomic,strong) NSLayoutConstraint *collapsedConstraint;
@property (nonatomic,strong) NSLayoutConstraint *expandedConstraint;

@end

NSString * const PWDStatsTableCellIdentifier = @"PWDStatsTableCellIdentifier";

@implementation PWDStatsViewController

- (void)loadView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    PWDChartScrollView *chartScrollView = [[PWDChartScrollView alloc] initWithFrame:CGRectZero];
    chartScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.chartScrollView = chartScrollView;
    
    _headerHeight = 32;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:chartScrollView];
    [view addSubview:tableView];
    self.view = view;
    
    id<UILayoutSupport> top = self.topLayoutGuide;
    id<UILayoutSupport> bottom = self.bottomLayoutGuide;
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(top,bottom,chartScrollView,tableView);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chartScrollView]|" options:0 metrics:nil views:viewDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:viewDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][chartScrollView][tableView][bottom]" options:0 metrics:nil views:viewDict]];
    NSLayoutConstraint *collapsedConstraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:0 constant:_headerHeight];
    [view addConstraint:collapsedConstraint];
    self.collapsedConstraint = collapsedConstraint;
    NSLayoutConstraint *expandedConstraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:chartScrollView attribute:NSLayoutAttributeHeight
                                                                         multiplier:kPWDGoldenRatio constant:0];
    [view addConstraint:expandedConstraint];
    self.expandedConstraint = expandedConstraint;
    collapsedConstraint.active = YES;
    expandedConstraint.active = NO;
    tableView.scrollEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    PWDTaskManager *taskManager = [PWDTaskManager sharedManager];
    
    NSManagedObjectContext *context = taskManager.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [taskManager.managedObjectModel entitiesByName][NSStringFromClass([PWDDailyRecord class])];
    fetchRequest.entity = entityDescription;
#ifdef DEBUG
    NSString *sortKey = NSStringFromSelector(@selector(createDateRaw));
#else
    NSString *sortKey = NSStringFromSelector(@selector(dateRaw));
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.chartScrollView updateChartWithRecords:self.fetchedResultsController.fetchedObjects];
    [self.chartScrollView scrollToMostRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.chartScrollView unhighlightRecordAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.chartScrollView highlightRecordAtIndex:indexPath.row];
    [self.chartScrollView scrollToRecord:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    _lastSelectedIndexPath = indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
    UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    expandButton.hidden = !self.fetchedResultsController.fetchedObjects.count;
    expandButton.enabled = !expandButton.hidden;
    [expandButton setTintColor:[UIColor flatOrangeColor]];
    [expandButton setImage:[UIImage imageNamed:@"ic_keyboard_arrow_up"] forState:UIControlStateNormal];
    [expandButton addTarget:self action:@selector(toggleTableView:) forControlEvents:UIControlEventTouchUpInside];
    expandButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.expandButton = expandButton;
    
    [view.contentView addSubview:expandButton];
    return view;
}

#pragma mark - Functions
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PWDDailyRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *recordDate = record.date;
    cell.textLabel.text = [self.dateFormatter stringFromDate:recordDate];
    UILabel *powerLabel = [UILabel new];
    powerLabel.text = record.powerText;
    [powerLabel sizeToFit];
    cell.accessoryView = powerLabel;
}

- (void)toggleTableView:(id)sender {
    PWDChartScrollView *chartScrollView = self.chartScrollView;
    UITableView *tableView = self.tableView;
    tableView.scrollEnabled = !tableView.scrollEnabled;
    BOOL expanding = tableView.scrollEnabled;
    chartScrollView.chartView.showTrendLine = !expanding;
    if (expanding) {
        [self.expandButton setTintColor:[UIColor grayColor]];
    } else {
        [self.expandButton setTintColor:[UIColor flatCarrotColor]];
        [chartScrollView unhighlightRecordAtIndex:_lastSelectedIndexPath.row];
        [tableView deselectRowAtIndexPath:_lastSelectedIndexPath animated:YES];
    }
    if (self.collapsedConstraint.active) {
        self.collapsedConstraint.active = NO;
        self.expandedConstraint.active = YES;
    } else {
        self.expandedConstraint.active = NO;
        self.collapsedConstraint.active = YES;
    }
    [chartScrollView setNeedsDisplay];
    [chartScrollView setNeedsLayout];
    [chartScrollView.chartView setNeedsDisplay];
    [chartScrollView.chartView setNeedsLayout];
    
    [UIView animateWithDuration:.5f
                          delay:0
         usingSpringWithDamping:.75f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                         [chartScrollView updateChartDisplay];
                         self.expandButton.transform = CGAffineTransformRotate(self.expandButton.transform, M_PI);

                     }
                     completion:^(BOOL finished) {
                         if (expanding) {
                             [self.chartScrollView.chartView clearHighlights];
                         } else {
                             [self.chartScrollView.chartView redrawForScrollOffset:chartScrollView.contentOffset.x];
                         }
                     }];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWDStatsTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PWDStatsTableCellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
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
    self.expandButton.hidden = !controller.fetchedObjects.count;
    self.expandButton.enabled = !self.expandButton.hidden;
    [self.chartScrollView scrollToMostRight];
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
