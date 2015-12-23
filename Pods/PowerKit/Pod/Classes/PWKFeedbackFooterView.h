//
//  PWKFeedbackFooterView.h
//  Pods
//
//  Created by Xu, Raymond on 12/23/15.
//
//

#import <UIKit/UIKit.h>

@protocol PWKFeedbackFooterViewDelegate;

@interface PWKFeedbackFooterView : UIView

@property (nonatomic,weak) UIButton *feedbackButton;
@property (nonatomic,weak) UIButton *rateButton;
@property (nonatomic,strong) NSURL *appStoreURL;

@property (nonatomic,weak) id<PWKFeedbackFooterViewDelegate> delegate;

@end

@protocol PWKFeedbackFooterViewDelegate <NSObject>

- (void)feedbackFooterView:(PWKFeedbackFooterView *)feedbackFooterView didTapFeedbackButton:(UIButton *)feedbackButton;

@end