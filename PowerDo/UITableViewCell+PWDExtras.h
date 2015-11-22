//
//  UITableViewCell+PWDExtras.h
//  PowerDo
//
//  Created by XU SHIYAN on 22/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (PWDExtras)

+ (NSString *)identifier;
+ (void)registerClassForTableView:(UITableView *)tableView;
+ (void)registerNibForTableView:(UITableView *)tableView;

@end
