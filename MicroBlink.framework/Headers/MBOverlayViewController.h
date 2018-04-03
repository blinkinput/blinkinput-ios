//
//  PPOverlayViewController.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 5/28/13.
//  Copyright (c) 2013 MicroBlink Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import "MBScanningRecognizerRunnerViewController.h"
#import "PPMicroBlinkDefines.h"
#import "MBOverlayContainerViewController.h"

#import "MBRecognizerResult.h"
#import "MBDisplayableQuadDetection.h"
#import "MBDisplayablePointsDetection.h"

#import "PPLivenessAction.h"
#import "PPLivenessError.h"
#import "MBOverlayViewControllerInterface.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBOcrRecognizerRunnerViewDelegate;
@protocol MBDetectionRecognizerRunnerViewDelegate;
@protocol MBScanningRecognizerRunnerViewDelegate;
@protocol MBRecognizerRunnerViewControllerDelegate;
@protocol MBDebugRecognizerRunnerViewDelegate;

@class MBOcrLayout;
@class MBMetadata;
@class PPRecognizerResult;


/**
 Overlay View Controller is an abstract class for all overlay views placed on top View Controller.

 It's responsibility is to provide meaningful and useful interface for the user to interact with.

 Typical actions which need to be allowed to the user are:

 - intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a
    "viewfinder" in which the user need to place the scanned object
 - a way to cancel the scanining, typically with a "cancel" or "back" button
 - a way to power on and off the light (i.e. "torch") button
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBOverlayViewController : UIViewController

/**
 Overlay View's delegate object. Responsible for sending messages to PhotoPay's
 Camera View Controller
 */
@property (nonatomic, weak) UIViewController<MBOverlayContainerViewController> *containerViewController;

/**
 * Delegate for Overlay View controllers which returns required MBSettings
 */
@property (nonatomic, weak) id<MBOverlayViewControllerInterface> overlayViewControllerInterfaceDelegate;

/**
 Overlay View's recognizer runner controller. Responsible for sending messages to camera view controller
 */
@property (nonatomic, strong) UIViewController<MBRecognizerRunnerViewController> *recognizerRunnerViewController;


/**
 Scanning region in which the scaning is performed.
 Image is cropped to this region.

 Should be provided in the following coordinate system.
 - Upper left point has coordinates (0.0f, 0.0f) and corresponds to upper left corner of the overlay view
 - Lower right corner has coordinates (1.0f, 1.0f) and corresponds to lower right corner of the overlay view

 CGRect provided here specifies the origin (upper left point) of the scanning region, and the size of the
 region in hereby described coordinating system.
 */
@property (nonatomic) CGRect scanningRegion;

/**
 * If YES, default camera overlay will display Cancel button.
 * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to NO.
 *
 * Default: YES.
 */
@property (nonatomic, assign) BOOL showCloseButton;

/**
 * If YES, default camera overlay will display Torch button.
 * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to NO.
 *
 * Default: YES.
 */
@property (nonatomic, assign) BOOL showTorchButton;

/**
 * If YES, default camera overlay will display Status bar.
 * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to YES.
 *
 * Default: NO.
 */
@property (nonatomic, assign) BOOL showStatusBar;

@end

NS_ASSUME_NONNULL_END
