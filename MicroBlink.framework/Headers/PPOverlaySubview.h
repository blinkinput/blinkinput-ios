//
//  PPOverlaySubview.h
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBDisplayableQuadDetection.h"
#import "MBDisplayablePointsDetection.h"

#import "PPLivenessAction.h"
#import "PPLivenessError.h"

#import "MBRecognizerResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PPOverlaySubviewDelegate;

@class MBOcrLayout;
@class MBMetadata;
@class MBOverlayViewController;
@class PPRecognizerResult;

/**
 * Common interface for all OverlaySubviews
 */
@protocol PPOverlaySubview <NSObject>

/** Delegate which is notified on Overlay events */
@property (nonatomic, weak, nullable) id<PPOverlaySubviewDelegate> delegate;

/** The overlay view controller containing this overlay subview (if any) */
@property (nonatomic, weak) MBOverlayViewController *overlay;

@optional

/**
 Overlay view appears and the scanning resumes. This happens when the camera view
 is opened, or when the app enters foreground with camera view displayed.
 */
- (void)overlayDidResumeScanning;

/**
 Overlay disappears and the scanning pauses. This happens when the camera view
 is closed, or when the app enters background with camera view displayed.
 */
- (void)overlayDidStopScanning;

/**
 Overlay ended the recognition cycle with a certain result.
 The scanning result cannot be considered as valid, sometimes here are received objects which
 contain only partial scanning information.

 Use this method only if you need UI update on this event (although this is unnecessary in many cases).

 If you're interested in valid data, use cameraViewController:didOutputResults: method
 */
- (void)overlayDidFinishRecognition;

/**
 * Overlay reports the status of the object detection. Scanning status contain information
 * about whether the scan was successful, whether the user holds the device too far from
 * the object, whether the angles was too high, or the object isn't seen on the camera in
 * it's entirety. If the object was found, the corner points of the object are returned.
 */
- (void)overlayDidFinishDetectionWithDisplayableQuad:(MBDisplayableQuadDetection *)displayableQuadDetection;

/**
 * Overlay reports the status of the object detection. Scanning status contain information
 * about whether the scan was successful, whether the user holds the device too far from
 * the object, whether the angles was too high, or the object isn't seen on the camera in
 * it's entirety. If the object was found, the corner points of the object are returned.
 */
- (void)overlayDidFinishDetectionWithDisplayablePoints:(MBDisplayablePointsDetection *)displayablePointsDetection;

/**
 * Overlay reports obtained ocr layout
 *
 * Besides the ocr layout itself, we get the ID of the layout so we can
 * distinguish consecutive layouts of the same area on the image
 */
- (void)overlayDidObtainOcrLayout:(MBOcrLayout *)ocrLayout withIdentifier:(NSString *)identifier;

/**
 * Overlay ended with recognition metadata.
 * This is always called *before* method did output results
 *
 *  @param metadata             returned metadata
 */
- (void)overlayDidOutputMetadata:(MBMetadata *)metadata;

/**
 NOTE: This is called on processing thread
 */
- (void)overlayDidOutputResultsForState:(MBRecognizerResultState)state;

/**
 * Overlay was tapped and focusing at the given point is initiated
 */
- (void)willFocusAtPoint:(CGPoint)point;

@end

/**
 Base class for all overlay subviews
 */
PP_CLASS_AVAILABLE_IOS(6.0)
@interface PPOverlaySubview : UIView <PPOverlaySubview>

@end

/**
 * Protocol which all objects interested in receiving information about overlay subviews need to implement
 */
@protocol PPOverlaySubviewDelegate <NSObject>

/** Delegate method called when animation starts */
- (void)overlaySubviewAnimationDidStart:(PPOverlaySubview *)overlaySubview;

/** Delegate method called when animation finishes */
- (void)overlaySubviewAnimationDidFinish:(PPOverlaySubview *)overlaySubview;

@end

NS_ASSUME_NONNULL_END
