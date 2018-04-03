//
//  MBOcrRecognizerRunnerDelegate.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 20/12/2017.
//

@class MBRecognizerRunner;
@class MBOcrLayout;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining ocr results
 */
@protocol MBOcrRecognizerRunnerDelegate <NSObject>
@required

- (void)recognizerRunner:(nonnull MBRecognizerRunner *)recognizerRunner
      didObtainOcrResult:(MBOcrLayout *)ocrResult
          withResultName:(NSString *)resultName;

@end

NS_ASSUME_NONNULL_END
