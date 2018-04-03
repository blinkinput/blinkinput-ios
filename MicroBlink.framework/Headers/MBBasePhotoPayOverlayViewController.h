//
//  MBBasePhotoPayOverlayViewController.h
//  PhotoPayFramework
//
//  Created by Jura on 09/06/14.
//  Copyright (c) 2014 MicroBlink Ltd. All rights reserved.
//

#import "MBBaseOverlayViewController.h"

PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBBasePhotoPayOverlayViewController : MBBaseOverlayViewController

/**
 Margin for the buttons in heads up display
 */
@property (nonatomic, assign) CGFloat buttonsMargin;

/**
 Supported orientations mask
 */
@property (nonatomic, assign) UIInterfaceOrientationMask hudMask;

/**
 YES if help button should be displayed
 */
@property (nonatomic, assign) BOOL shouldDisplayHelpButton;

@end
