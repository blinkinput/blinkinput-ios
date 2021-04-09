//
//  MBGlareRecognizerRunnerDelegate.h
//  MicroblinkDev
//
//  Created by DoDo on 24/04/2018.
//

#ifndef MBGlareRecognizerRunnerDelegate_h
#define MBGlareRecognizerRunnerDelegate_h

@class MBIRecognizerRunner;

@protocol MBIGlareRecognizerRunnerDelegate <NSObject>
@required

/**
 * Called when scanning library finishes glare detection.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void) recognizerRunner:(nonnull MBIRecognizerRunner *)recognizerRunner didFinishGlareDetectionWithResult:(BOOL)glareFound;
@end


#endif /* MBGlareRecognizerRunnerDelegate_h */
