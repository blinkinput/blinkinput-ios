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

@protocol MBIFieldByFieldOverlayViewControllerDelegate;

/**
 * View Controller responsible for view hierarchy for Form OCR scannning.
 * This view hierarchy is added as an overlay to Camera preview
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIFieldByFieldOverlayViewController : MBIOverlayViewController

/**
 * Designated initializer of the overlay. All scan settings from the recognizer runner will be removed and generated anew with passed MBIScanElement array.
 */
- (instancetype)initWithSettings:(MBIFieldByFieldOverlaySettings *)settings delegate:(id<MBIFieldByFieldOverlayViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

MB_INIT_UNAVAILABLE;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 * Delegate which is notified with important UI events
 */
@property(nonatomic, weak) id<MBIFieldByFieldOverlayViewControllerDelegate> delegate;

@end

/**
 * Protocol for observing important events with scanning
 */
@protocol MBIFieldByFieldOverlayViewControllerDelegate <NSObject>

@required
/**
 * Called when Overlay will close. This can happen if the user pressed close button
 *
 * Perform here your VC dismiss logic.
 *
 *  @param fieldByFieldOverlayViewController    View Controller responsible for scanning
 */
- (void)fieldByFieldOverlayViewControllerWillClose:(MBIFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController;

/**
 * Called when Scanning finishes and Overlay will dissapear.
 *
 * Perform here your VC dismiss logic, as well as result handling
 *
 *  @param fieldByFieldOverlayViewController           View Controller responsible for scanning
 *  @param scanElements                                Array of MBIScanElement objects with all scanning results
 */
- (void)fieldByFieldOverlayViewController:(MBIFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController didFinishScanningWithElements:(NSArray<MBIScanElement *> *)scanElements;

@optional
/**
 * Called when user pressed the help button on the overlay.
 *
 * Perform logic showing your help instructions here.
 *
 *  @param fieldByFieldOverlayViewController    View Controller responsible for scanning
 */
- (void)fieldByFieldOverlayViewControllerWillPresentHelp:(MBIFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController;

/**
 * Outputs back each image processed by the SDK.
 *
 *  @param fieldByFieldOverlayViewController    View Controller responsible for scanning
 *  @param currentImage                         Current image being processed
 */
- (void)fieldByFieldOverlayViewController:(MBIFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController didOutputCurrentImage:(MBIImage *)currentImage;

@end

NS_ASSUME_NONNULL_END
