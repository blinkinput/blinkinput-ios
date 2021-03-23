//
//  MBOcrRecognizerRunnerDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 20/12/2017.
//

@class MBINRecognizerRunner;
@class MBINOcrLayout;

/**
 * Protocol for obtaining ocr results
 */
@protocol MBINOcrRecognizerRunnerDelegate <NSObject>
@required

/**
 * Called when Scanning library has MBINOcrLayout available and ready to be displayed on UI.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)recognizerRunner:(nonnull MBINRecognizerRunner *)recognizerRunner
      didObtainOcrResult:(nonnull MBINOcrLayout *)ocrResult
          withResultName:(nonnull NSString *)resultName;

@end
