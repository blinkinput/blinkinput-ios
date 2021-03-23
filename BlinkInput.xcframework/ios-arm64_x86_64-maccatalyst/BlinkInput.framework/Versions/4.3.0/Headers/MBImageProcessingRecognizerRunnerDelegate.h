//
//  MBImageProcessingDelegate.h
//  Microblink
//
//  Created by DoDo on 07/05/2018.
//

@class MBINRecognizerRunner;
@class MBINImage;

@protocol MBINImageProcessingRecognizerRunnerDelegate <NSObject>
@required

/**
 * Called when MBINRecognizerRunner finishes processing given image.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void) recognizerRunner:(nonnull MBINRecognizerRunner *)recognizerRunner didFinishProcessingImage:(nonnull MBINImage *)image;

@end
