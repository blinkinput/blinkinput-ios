//
//  MBGlareRecognizerRunnerViewControllerDelegate.h
//  MicroblinkDev
//
//  Created by DoDo on 24/04/2018.
//

#ifndef MBGlareRecognizerRunnerViewControllerDelegate_h
#define MBGlareRecognizerRunnerViewControllerDelegate_h

#import <Foundation/Foundation.h>

@protocol MBINRecognizerRunnerViewController;

@protocol MBINGlareRecognizerRunnerViewControllerDelegate <NSObject>
@required

/**
 * Called when scanning library finishes glare detection.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void) recognizerRunnerViewController:(nonnull UIViewController<MBINRecognizerRunnerViewController> *)recognizerRunnerViewController didFinishGlareDetectionWithResult:(BOOL)glareFound;
@end


#endif /* MBGlareRecognizerRunnerViewControllerDelegate_h */
