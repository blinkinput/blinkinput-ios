//
//  MBOcrRecognizerRunnerViewDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 18/12/2017.
//

#import <Foundation/Foundation.h>

@class MBIOcrLayout;
@protocol MBIRecognizerRunnerViewController;

/**
 * Protocol for obtaining ocr results
 */
@protocol MBIOcrRecognizerRunnerViewControllerDelegate <NSObject>
@required

/**
 * Called when scanning library has MBIOcrLayout ready to be displayed on UI.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)recognizerRunnerViewController:(nonnull UIViewController<MBIRecognizerRunnerViewController> *)recognizerRunnerViewController
                    didObtainOcrResult:(nonnull MBIOcrLayout *)ocrResult
                        withResultName:(nonnull NSString *)resultName;

@end
