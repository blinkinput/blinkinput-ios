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

@protocol MBIBarcodeOverlayViewControllerDelegate;

@class MBIBarcodeOverlaySettings;
@class MBIRecognizerCollection;

MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIBarcodeOverlayViewController : MBIBaseOverlayViewController

/**
 * Common settings
 */
@property (nonatomic, strong, readonly) MBIBarcodeOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBIBarcodeOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBIBarcodeOverlaySettings object
 *
 *  @param recognizerCollection MBIRecognizerCollection object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBIBarcodeOverlaySettings *)settings recognizerCollection:(MBIRecognizerCollection *)recognizerCollection delegate:(nonnull id<MBIBarcodeOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
