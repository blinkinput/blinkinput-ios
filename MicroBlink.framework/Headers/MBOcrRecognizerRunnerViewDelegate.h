//
//  MBOcrRecognizerRunnerViewDelegate.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 18/12/2017.
//

#import <Foundation/Foundation.h>
#import "MBScanningRecognizerRunnerViewController.h"

@class MBOcrLayout;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining ocr results
 */
@protocol MBOcrRecognizerRunnerViewDelegate <NSObject>
@required

- (void)recognizerRunnerViewController:(nonnull UIViewController<MBRecognizerRunnerViewController> *)recognizerRunnerViewController
                    didObtainOcrResult:(MBOcrLayout *)ocrResult
                        withResultName:(NSString *)resultName;

@end

NS_ASSUME_NONNULL_END
