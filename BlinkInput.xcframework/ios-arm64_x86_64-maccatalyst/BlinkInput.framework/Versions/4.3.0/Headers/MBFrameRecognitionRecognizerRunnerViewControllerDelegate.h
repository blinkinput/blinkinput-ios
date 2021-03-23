//
//  MBFrameRecognitionRecognizerRunnerViewControllerDelegate.h
//  BlinkShowcaseDev
//
//  Created by Jura Skrlec on 02/12/2020.
//

#ifndef MBFrameRecognitionRecognizerRunnerViewControllerDelegate_h
#define MBFrameRecognitionRecognizerRunnerViewControllerDelegate_h

#import "MBRecognizerResult.h"

@protocol MBINRecognizerRunnerViewController;

/**
 * Protocol for obtaining frame recognition
 */
@protocol MBINFrameRecognitionRecognizerRunnerViewControllerDelegate <NSObject>
@required
/**
 * Scanning library did output frame with state
 *
 *  @param recognizerRunnerViewController scanningViewController Scanning view controller responsible for scanning
 *  @param state                  state of scanning
 */
- (void)recognizerRunnerViewControllerDidFinishFrameRecognition:(nonnull UIViewController<MBINRecognizerRunnerViewController> *)recognizerRunnerViewController state:(MBINRecognizerResultState)state;

@end

#endif /* MBFrameRecognitionRecognizerRunnerViewControllerDelegate_h */
