//
//  PWDFeedbackService.h
//  PowerDo
//
//  Created by Wang Jin on 17/9/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PWDFeedbackMood) {
    PWDFeedbackMoodNone,
    PWDFeedbackMoodHappy,
    PWDFeedbackMoodUnhappy
};

@interface PWDFeedbackService : NSObject

@property (nonatomic) enum PWDFeedbackMood mood;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *userEmail;

@end
