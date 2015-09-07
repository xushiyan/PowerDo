//
//  PWDTodayViewController.m
//  PowerDo
//
//  Created by Wang Jin on 7/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTodayViewController.h"

@interface PWDTodayViewController () {
    NSMutableArray *_todayTasks;
}


@end

@implementation PWDTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = self.tableView;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _todayTasks.count;
}

@end
