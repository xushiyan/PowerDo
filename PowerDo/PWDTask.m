//
//  PWDTask.m
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import "PWDTask.h"

@implementation PWDTask


- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title ? title : @"";
    }
    return self;
}

- (instancetype)init {
    return [self initWithTitle:@""];
}
@end
