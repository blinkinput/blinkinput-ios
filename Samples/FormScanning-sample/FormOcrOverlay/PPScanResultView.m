//
//  PPScanResultView.m
//  BlinkOCR
//
//  Created by Jura on 01/03/15.
//  Copyright (c) 2015 PhotoPay. All rights reserved.
//

#import "PPScanResultView.h"

@interface PPScanResultView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *textContainerView;

@property (nonatomic, strong) UIView* borderView;

@property (nonatomic, assign) CGFloat topMargin;

@end

@implementation PPScanResultView

- (void)animateShowFromPoint:(CGPoint)point
                    toBounds:(CGRect)bounds
                      center:(CGPoint)center
           animationDuration:(NSTimeInterval)animationDuration
                  completion:(void (^)(BOOL finished))completion {

    self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.center = point;

    self.alpha = 1.0f;
    self.hidden = NO;

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.center = center;
                         self.bounds = bounds;
                     }
                     completion:completion];
}

- (void)animateHideToPoint:(CGPoint)point
         animationDuration:(NSTimeInterval)animationDuration
                completion:(void (^)(BOOL finished))completion {

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.bounds = CGRectMake(0, 0, 0, 0);
                         self.center = point;
                         self.alpha = 0.2f;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         self.alpha = 0.0f;
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

+ (instancetype)allocFromNibName:(NSString*)nibName {
    PPScanResultView *resultView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];

    resultView.textField.delegate = resultView;
    resultView.textField.adjustsFontSizeToFitWidth = YES;

    return resultView;
}

@end
