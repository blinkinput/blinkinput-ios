//
//  MBBarcodeOverlayViewController.h
//  BarcodeFramework
//
//  Created by Jura on 22/12/13.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import "MBModernBaseOverlayViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBBarcodeOverlayViewControllerDelegate;

@class MBSettings;
@class MBBarcodeOverlaySettings;

PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBBarcodeOverlayViewController : MBModernBaseOverlayViewController

/**
 * Supported orientations mask
 */
@property (nonatomic, assign) UIInterfaceOrientationMask hudMask;

/**
 * Common settings
 */
@property (nonatomic, strong, readonly) MBBarcodeOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBBarcodeOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBSettings object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBBarcodeOverlaySettings *)settings andDelegate:(id<MBBarcodeOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
