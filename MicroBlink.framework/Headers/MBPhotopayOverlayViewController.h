//
//  PPModernOverlayViewController.h
//  PhotoPayFramework
//
//  Created by Marko Mihovilić on 01/09/14.
//  Copyright (c) 2014 MicroBlink Ltd. All rights reserved.
//

#import "MBModernBaseOverlayViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MBSettings;
@class MBPhotopayOverlaySettings;

/**
 * Default version of overlay view controller with modern design.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBPhotopayOverlayViewController : MBModernBaseOverlayViewController

/**
 * Supported orientations mask
 */
@property (nonatomic, assign) UIInterfaceOrientationMask hudMask;

/**
 * Common photopay UI settings
 */
@property (nonatomic, strong, readonly) MBPhotopayOverlaySettings *settings;

/**
 * Designated intializer.
 *
 *  @param settings MBPhotopayOverlaySettings object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBPhotopayOverlaySettings *)settings;

@end

NS_ASSUME_NONNULL_END
