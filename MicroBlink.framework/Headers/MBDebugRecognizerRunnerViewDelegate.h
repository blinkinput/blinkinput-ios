//
//  MBDebugRecognizerRunnerViewDelegate.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 04/01/2018.
//

#import <Foundation/Foundation.h>
#import "MBScanningRecognizerRunnerViewController.h"

@class MBMetadata;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining debug metadata
 */
@protocol MBDebugRecognizerRunnerViewDelegate <NSObject>
@required
/**
 * Scanning library did output debug metadata
 */

- (void)recognizerRunnerViewControllerDidOutputDebugMetadata:(nonnull UIViewController<MBRecognizerRunnerViewController> *)recognizerRunnerViewController metadata:(MBMetadata *)metadata;

@end

NS_ASSUME_NONNULL_END
