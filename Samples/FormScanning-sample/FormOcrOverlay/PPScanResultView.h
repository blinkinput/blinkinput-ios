//
//  PPScanResultView.h
//  BlinkOCR
//
//  Created by Jura on 01/03/15.
//  Copyright (c) 2015 PhotoPay. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * View responsible for displaying scannng result
 */
@interface PPScanResultView : UIView

/**
 * Text field which can be used to manually edit the text
 */
@property (weak, nonatomic) IBOutlet UITextField *textField;

/**
 * Animates the display of scan result view.
 * 
 * Animation emerges from the point "point", and moves to the frame specified by "bounds" and "center".
 * Animation duration is specified by animationDuration, and completion block by "completion"
 *
 *  @param point             emerging point of the animation
 *  @param bounds            bounds of the view after the animation
 *  @param center            center of the view after the animation
 *  @param animationDuration duration of the animation
 *  @param completion        completion block
 */
- (void)animateShowFromPoint:(CGPoint)point
                    toBounds:(CGRect)bounds
                      center:(CGPoint)center
           animationDuration:(NSTimeInterval)animationDuration
                  completion:(void (^)(BOOL finished))completion;

/**
 * Animates the hiding of the scan result view
 *
 *  @param point             vanishing point of the animation
 *  @param animationDuration duration of the animation
 *  @param completion        completion block
 */
- (void)animateHideToPoint:(CGPoint)point
         animationDuration:(NSTimeInterval)animationDuration
                completion:(void (^)(BOOL finished))completion;

/**
 * Used for easier instantiation from Nib file
 *
 *  @param nibName Name of the nib file
 *
 *  @return Scan result view instance
 */
+ (instancetype)allocFromNibName:(NSString*)nibName;

@end
