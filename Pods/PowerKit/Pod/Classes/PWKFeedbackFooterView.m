//
//  PWKFeedbackFooterView.m
//  Pods
//
//  Created by Xu, Raymond on 12/23/15.
//
//

#import "PWKFeedbackFooterView.h"

@interface PWKFeedbackFooterView ()


@end

@implementation PWKFeedbackFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *feedback = [UIButton buttonWithType:UIButtonTypeSystem];
        [feedback setTitle:NSLocalizedString(@"Feedback", @"") forState:UIControlStateNormal];
        [feedback setImage:[UIImage imageNamed:@"ic_mail_outline_18pt"] forState:UIControlStateNormal];
        feedback.titleLabel.font = [UIFont systemFontOfSize:14];
        [feedback addTarget:self action:@selector(openMailComposer:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rate = [UIButton buttonWithType:UIButtonTypeSystem];
        [rate setTitle:NSLocalizedString(@"Rate on AppStore", @"") forState:UIControlStateNormal];
        [rate setImage:[UIImage imageNamed:@"ic_star_border_18pt"] forState:UIControlStateNormal];
        rate.titleLabel.font = [UIFont systemFontOfSize:14];
        [rate addTarget:self action:@selector(openAppItemPage:) forControlEvents:UIControlEventTouchUpInside];
        
        UIStackView *horizontalStack = [[UIStackView alloc] initWithArrangedSubviews:@[feedback,rate]];
        horizontalStack.axis = UILayoutConstraintAxisHorizontal;
        horizontalStack.distribution = UIStackViewDistributionFillEqually;
        horizontalStack.alignment = UIStackViewAlignmentCenter;
        horizontalStack.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:horizontalStack];
        
        NSDictionary *viewDict = NSDictionaryOfVariableBindings(horizontalStack);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[horizontalStack]|" options:0 metrics:nil views:viewDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[horizontalStack]|" options:0 metrics:nil views:viewDict]];
    }
    return self;
}

- (void)openMailComposer:(id)sender {
    [self.delegate feedbackFooterView:self didTapFeedbackButton:self.feedbackButton];
}

- (void)openAppItemPage:(id)sender {
    [[UIApplication sharedApplication] openURL:self.appStoreURL];
}

@end
