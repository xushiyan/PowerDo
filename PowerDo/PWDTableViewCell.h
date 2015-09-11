//
//  PWDTableViewCell.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWDTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (void)registerClassForTableView:(UITableView *)tableView;
+ (void)registerNibForTableView:(UITableView *)tableView;

@end
