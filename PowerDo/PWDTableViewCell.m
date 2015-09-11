//
//  PWDTableViewCell.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTableViewCell.h"

@implementation PWDTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (void)registerForTableView:(UITableView *)tableView {
    [tableView registerClass:self.class forCellReuseIdentifier:[self.class identifier]];
}

@end
