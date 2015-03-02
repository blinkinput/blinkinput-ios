//
//  PhotoPay.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 3/29/12.
//  Copyright (c) 2012 MicroBlink Ltd. All rights reserved.
//

#ifndef PhotoPayFramework_PPScanner_h
#define PhotoPayFramework_PPScanner_h

#import "PPSettings.h"

#import "PPOcrRecognizerSettings.h"

#import "PPApp.h"
#import "PPCoordinator.h"
#import "PPBaseResult.h"
#import "PPOcrScanResult.h"
#import "PPDetectionStatus.h"
#import "PPCameraImage.h"
#import "PPOverlayViewController.h"
#import "PPScanningViewController.h"

/**
 * Protocol for obtaining scanning results
 */
@protocol PPScanDelegate <NSObject>
@required

/**
 * Scanning library requested authorization for Camera access from the user, but the user declined it.
 * This case means scanning cannot be performed, because accessing camera images is now allowed.
 *
 * In this callback you have the chance to handle this case and present some kind of a message to the user on top
 * of scanningViewController.
 */
- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController>*)scanningViewController;

/**
 * Scanning library returned with error. The error object is returned and contains
 * description of the error, in a specified language. Do your error handling here.
 *
 * This is where the scanningViewController should be dismissed
 * if it's presented modally. 
 */
- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
            didFinishWithError:(NSError*)error;

/**
 * Scanning library did output scanning results. Do your next steps here.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the scanningViewController here.
 *
 * This method is the default way for getting access to results of scanning.
 *
 * Note:
 * - there may be more 0, 1, or more than one scanning results.
 * - each scanning result belongs to a common PPBaseResult type. Check it's property resultType to get the actual type
 * - handle different types differently
 *
 * @see PPBaseResult
 * @see PPRecognitionResult
 */
- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
              didOutputResults:(NSArray*)results;

@optional

/**
 * Called when Scanning library wants to display help screens. This can happen when the user press
 * help button on scanning UI, or on first run of the application
 */
- (void)scanningViewControllerShouldPresentHelp:(UIViewController<PPScanningViewController>*)scanningViewController;

/**
 * Called when Scanning library requires the display of more info view
 */
- (void)scanningViewControllerDidRequestMoreInfo:(UIViewController<PPScanningViewController>*)scanningViewController;

/** 
 Called when coordinator obtaines intermediate images 
 
 Intended for private PhotoPay use.
 */
- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
                 obtainedImage:(id<PPCameraImage>)image
                      withName:(NSString *)name
                          type:(NSString *)type;

/** 
 Called when coordinator obtaines intermediate texts
 
 Intended for private PhotoPay use.
 */
- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
                  obtainedText:(NSString*)text
                      withName:(NSString*)name
                          type:(NSString*)type;

@end

#endif
