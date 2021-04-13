//
//  MBImageProcessingDelegate.h
//  Microblink
//
//  Created by DoDo on 07/05/2018.
//

@class MBIRecognizerRunner;
@class MBIImage;

@protocol MBIImageProcessingRecognizerRunnerDelegate <NSObject>
@required

/**
 * Called when MBIRecognizerRunner finishes processing given image.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void) recognizerRunner:(nonnull MBIRecognizerRunner *)recognizerRunner didFinishProcessingImage:(nonnull MBIImage *)image;

@end
