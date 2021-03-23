//
//  PPFieldByFieldOverlayViewController.h
//  BlinkOCR
//
//  Created by Jura on 01/03/15.
//  Copyright (c) 2015 PhotoPay. All rights reserved.
//

#import "MBOverlayViewController.h"
#import "MBScanElement.h"
#import "MBImage.h"
#import "MBFieldByFieldOverlaySettings.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBINFieldByFieldOverlayViewControllerDelegate;

/**
 * View Controller responsible for view hierarchy for Form OCR scannning.
 * This view hierarchy is added as an overlay to Camera preview
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINFieldByFieldOverlayViewController : MBINOverlayViewController

/**
 * Designated initializer of the overlay. All scan settings from the recognizer runner will be removed and generated anew with passed MBINScanElement array.
 */
- (instancetype)initWithSettings:(MBINFieldByFieldOverlaySettings *)settings delegate:(id<MBINFieldByFieldOverlayViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

MB_INIT_UNAVAILABLE;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 * Delegate which is notified with important UI events
 */
@property(nonatomic, weak) id<MBINFieldByFieldOverlayViewControllerDelegate> delegate;

@end

/**
 * Protocol for observing important events with scanning
 */
@protocol MBINFieldByFieldOverlayViewControllerDelegate <NSObject>

@required
/**
 * Called when Overlay will close. This can happen if the user pressed close button
 *
 * Perform here your VC dismiss logic.
 *
 *  @param fieldByFieldOverlayViewController    View Controller responsible for scanning
 */
- (void)fieldByFieldOverlayViewControllerWillClose:(MBINFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController;

/**
 * Called when Scanning finishes and Overlay will dissapear.
 *
 * Perform here your VC dismiss logic, as well as result handling
 *
 *  @param fieldByFieldOverlayViewController           View Controller responsible for scanning
 *  @param scanElements                                Array of MBINScanElement objects with all scanning results
 */
- (void)fieldByFieldOverlayViewController:(MBINFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController didFinishScanningWithElements:(NSArray<MBINScanElement *> *)scanElements;

@optional
/**
 * Called when user pressed the help button on the overlay.
 *
 * Perform logic showing your help instructions here.
 *
 *  @param fieldByFieldOverlayViewController    View Controller responsible for scanning
 */
- (void)fieldByFieldOverlayViewControllerWillPresentHelp:(MBINFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController;

/**
 * Outputs back each image processed by the SDK.
 *
 *  @param fieldByFieldOverlayViewController    View Controller responsible for scanning
 *  @param currentImage                         Current image being processed
 */
- (void)fieldByFieldOverlayViewController:(MBINFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController didOutputCurrentImage:(MBINImage *)currentImage;

@end

NS_ASSUME_NONNULL_END
