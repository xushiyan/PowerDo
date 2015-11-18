//
//  PWDRootViewController.m
//  PowerDo
//
//  Created by XU SHIYAN on 18/11/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDRootViewController.h"
#import "PWDPlanViewController.h"
#import "PWDTodayViewController.h"
#import "PWDStatsViewController.h"
#import "PWDSettingsViewController.h"
#import "PWDConstants.h"

@interface PWDRootViewController ()

@property (nonatomic,strong) id todayBadgeValueChangeObserver;

@end

@implementation PWDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PWDPlanViewController *plan_vc = [[PWDPlanViewController alloc] initWithStyle:UITableViewStyleGrouped];
    plan_vc.title = NSLocalizedString(@"Plan", @"Plan tab title");
    plan_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:plan_vc.title image:[UIImage imageNamed:@"ic_assignment"] tag:PWDRootTabPlan];
    UINavigationController *plan_nc = [[UINavigationController alloc] initWithRootViewController:plan_vc];
    
    PWDTodayViewController *today_vc = [[PWDTodayViewController alloc] initWithStyle:UITableViewStyleGrouped];
    today_vc.title = NSLocalizedString(@"Today", @"Today tab title");
    today_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:today_vc.title image:[UIImage imageNamed:@"ic_today"] tag:PWDRootTabToday];
    UINavigationController *today_nc = [[UINavigationController alloc] initWithRootViewController:today_vc];
    
    PWDStatsViewController *stats_vc = [[PWDStatsViewController alloc] init];
    stats_vc.title = NSLocalizedString(@"Stats", @"Stats tab title");
    stats_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:stats_vc.title image:[UIImage imageNamed:@"ic_insert_chart"] tag:PWDRootTabStats];
    UINavigationController *stats_nc = [[UINavigationController alloc] initWithRootViewController:stats_vc];
    
    PWDSettingsViewController *settings_vc = [[PWDSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settings_vc.title = NSLocalizedString(@"Settings", @"Settings tab title");
    settings_vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:settings_vc.title image:[UIImage imageNamed:@"ic_settings"] tag:PWDRootTabSettings];
    UINavigationController *settings_nc = [[UINavigationController alloc] initWithRootViewController:settings_vc];
    
    self.viewControllers = @[plan_nc,today_nc,stats_nc,settings_nc];
    
    self.todayBadgeValueChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:PWDTodayBadgeValueChangeNotification
                                                                                           object:nil
                                                                                            queue:[NSOperationQueue mainQueue]
                                                                                       usingBlock:^(NSNotification * _Nonnull note) {
                                                                                           if ([note.object integerValue] > 0) {
                                                                                               today_vc.tabBarItem.badgeValue = [note.object stringValue];
                                                                                           } else {
                                                                                               today_nc.tabBarItem.badgeValue = nil;
                                                                                           }
                                                                                       }];
    [[NSNotificationCenter defaultCenter] postNotificationName:PWDTodayBadgeValueNeedsUpdateNotification object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.todayBadgeValueChangeObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
