//
//  MBOcrRecognizerRunnerDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 20/12/2017.
//

@class MBIRecognizerRunner;
@class MBIOcrLayout;

/**
 * Protocol for obtaining ocr results
 */
@protocol MBIOcrRecognizerRunnerDelegate <NSObject>
@required

/**
 * Called when Scanning library has MBIOcrLayout available and ready to be displayed on UI.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)recognizerRunner:(nonnull MBIRecognizerRunner *)recognizerRunner
      didObtainOcrResult:(nonnull MBIOcrLayout *)ocrResult
          withResultName:(nonnull NSString *)resultName;

@end
