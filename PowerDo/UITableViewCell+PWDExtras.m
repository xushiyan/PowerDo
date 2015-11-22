//
//  UITableViewCell+PWDExtras.m
//  PowerDo
//
//  Created by XU SHIYAN on 22/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "UITableViewCell+PWDExtras.h"

@implementation UITableViewCell (PWDExtras)

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
