//
//  PWDTask.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/2/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWDTask : NSObject

- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;

@property (nonatomic,copy) NSString *title;

@end
