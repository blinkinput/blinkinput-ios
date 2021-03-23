//
//  MBBarcodeOverlayViewController.h
//  BarcodeFramework
//
//  Created by Jura on 22/12/13.
//  Copyright (c) 2015 Microblink Ltd. All rights reserved.
//

#import "MBBaseOverlayViewController.h"
#import "MBBarcodeOverlaySettings.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBINBarcodeOverlayViewControllerDelegate;

@class MBINBarcodeOverlaySettings;
@class MBINRecognizerCollection;

MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINBarcodeOverlayViewController : MBINBaseOverlayViewController

/**
 * Common settings
 */
@property (nonatomic, strong, readonly) MBINBarcodeOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBINBarcodeOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBINBarcodeOverlaySettings object
 *
 *  @param recognizerCollection MBINRecognizerCollection object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBINBarcodeOverlaySettings *)settings recognizerCollection:(MBINRecognizerCollection *)recognizerCollection delegate:(nonnull id<MBINBarcodeOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
