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

+ (void)registerClassForTableView:(UITableView *)tableView {
    [tableView registerClass:self forCellReuseIdentifier:[self identifier]];
}

+ (void)registerNibForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:[self identifier]];
}

@end
