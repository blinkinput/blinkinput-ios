//
//  MBDetectionRecognizerRunnerViewDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 18/12/2017.
//

#import <Foundation/Foundation.h>

@class MBINDisplayablePointsDetection;
@class MBINDisplayableQuadDetection;
@protocol MBINRecognizerRunnerViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining detection results
 */
@protocol MBINDetectionRecognizerRunnerViewControllerDelegate <NSObject>
@optional
/**
 * Called when Scanning library finishes detection of objects.
 * Detection cycle happens before recognition cycle and it attempts to find the location of specific object on an image.
 * Since detection and recognition are two separate events, it is possible for detection to be successful while recognition can fail (not
 * vice versa).
 *
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 *
 * Returned MBINDisplayableQuadDetection object.
 *
 *  @param recognizerRunnerViewController scanningViewController recognizer runner view controller responsible for scanning
 *  @param displayableQuad displayable quad object detection containing information of detection (i.e. location)
 */
- (void)recognizerRunnerViewController:(nonnull UIViewController<MBINRecognizerRunnerViewController> *)recognizerRunnerViewController didFinishDetectionWithDisplayableQuad:(MBINDisplayableQuadDetection *)displayableQuad;

/**
 * Called when Scanning library finishes detection of objects.
 * Detection cycle happens before recognition cycle and it attempts to find the location of specific object on an image.
 * Since detection and recognition are two separate events, it is possible for detection to be successful while recognition can fail (not
 * vice versa).
 *
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 *
 * Returned MBINDisplayablePointsDetection object.
 *
 *  @param recognizerRunnerViewController scanningViewController recognizer runner view controller responsible for scanning
 *  @param displayablePoints points object detection containing information of detection (i.e. location)
 */
- (void)recognizerRunnerViewController:(nonnull UIViewController<MBINRecognizerRunnerViewController> *)recognizerRunnerViewController didFinishDetectionWithDisplayablePoints:(MBINDisplayablePointsDetection *)displayablePoints;

/**
 * Called when Scanning library fails to detect any object with any of the currently active recognizers.
 *
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 *
 * @param recognizerRunnerViewController Recognizer runner object responsible for scanning
 */
- (void)recognizerRunnerViewControllerDidFailDetection:(nonnull UIViewController<MBINRecognizerRunnerViewController> *)recognizerRunnerViewController;

@end

NS_ASSUME_NONNULL_END
