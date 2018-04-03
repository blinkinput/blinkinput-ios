//
//  MBDetectionRecognizerRunnerViewDelegate.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 18/12/2017.
//

#import <Foundation/Foundation.h>
#import "MBScanningRecognizerRunnerViewController.h"

@class MBDisplayablePointsDetection;
@class MBDisplayableQuadDetection;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining detection results
 */
@protocol MBDetectionRecognizerRunnerViewDelegate <NSObject>
@required
/**
 * Called when Scanning library finishes detection of objects.
 * Detection cycle happens before recognition cycle and it attempts to find the location of specific object on an image.
 * Since detection and recognition are two separate events, it is possible for detection to be successful while recognition can fail (not
 * vice versa).
 *
 * Returned MBDisplayableQuadDetection object.
 *
 *  @param recognizerRunnerViewController scanningViewController recognizer runner view controller responsible for scanning
 *  @param displayableQuad displayable quad object detection containing information of detection (i.e. location)
 */
- (void)recognizerRunnerViewController:(nonnull UIViewController<MBRecognizerRunnerViewController> *)recognizerRunnerViewController didFinishDetectionWithDisplayableQuad:(MBDisplayableQuadDetection *)displayableQuad;

/**
 * Called when Scanning library finishes detection of objects.
 * Detection cycle happens before recognition cycle and it attempts to find the location of specific object on an image.
 * Since detection and recognition are two separate events, it is possible for detection to be successful while recognition can fail (not
 * vice versa).
 *
 * Returned MBDisplayablePointsDetection object.
 *
 *  @param recognizerRunnerViewController scanningViewController recognizer runner view controller responsible for scanning
 *  @param displayablePoints points object detection containing information of detection (i.e. location)
 */
- (void)recognizerRunnerViewController:(nonnull UIViewController<MBRecognizerRunnerViewController> *)recognizerRunnerViewController didFinishDetectionWithDisplayablePoints:(MBDisplayablePointsDetection *)displayablePoints;

@end

NS_ASSUME_NONNULL_END
