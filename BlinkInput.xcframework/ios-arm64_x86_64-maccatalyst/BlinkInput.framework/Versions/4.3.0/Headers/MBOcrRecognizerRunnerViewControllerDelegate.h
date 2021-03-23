//
//  MBOcrRecognizerRunnerViewDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 18/12/2017.
//

#import <Foundation/Foundation.h>

@class MBINOcrLayout;
@protocol MBINRecognizerRunnerViewController;

/**
 * Protocol for obtaining ocr results
 */
@protocol MBINOcrRecognizerRunnerViewControllerDelegate <NSObject>
@required

/**
 * Called when scanning library has MBINOcrLayout ready to be displayed on UI.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)recognizerRunnerViewController:(nonnull UIViewController<MBINRecognizerRunnerViewController> *)recognizerRunnerViewController
                    didObtainOcrResult:(nonnull MBINOcrLayout *)ocrResult
                        withResultName:(nonnull NSString *)resultName;

@end
