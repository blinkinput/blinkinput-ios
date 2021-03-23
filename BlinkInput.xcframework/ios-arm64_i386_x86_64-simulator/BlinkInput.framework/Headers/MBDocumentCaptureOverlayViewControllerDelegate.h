//
//  MBDocumentCaptureOverlayViewControllerDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 13/01/2020.
//

#import <Foundation/Foundation.h>
#import "MBDocumentCaptureOverlayViewController.h"
#import "MBRecognizerRunnerViewController.h"
#import "MBRecognizerResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining scanning results
 */
@protocol MBINDocumentCaptureOverlayViewControllerDelegate <NSObject>
@required
/**
 * Scanning library did output scanning results
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the scanningViewController here.
 *
 * This method is the default way for getting access to results of scanning.
 *
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 *
 *  @param documentCaptureOverlayViewController documentCaptureOverlayViewController Scanning view controller responsible for document capture
 *  @param state state of scanning
 */
- (void)documentCaptureOverlayViewControllerDidFinishScanning:(nonnull MBINDocumentCaptureOverlayViewController *)documentCaptureOverlayViewController state:(MBINRecognizerResultState)state;

/**
 * Scanning library was closed, usually by the user pressing close button and cancelling the scan
 *
 *  @param documentCaptureOverlayViewController Scanning view controller responsible for document capture
 */
- (void)documentCaptureOverlayViewControllerDidTapClose:(nonnull MBINDocumentCaptureOverlayViewController *)documentCaptureOverlayViewController;

/**
 * Scanning library did output high resolution image
 *
 *  @param documentCaptureOverlayViewController Scanning view controller responsible for  document capture
 *  @param highResImage High resolution image of finished scan
 *
 *
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)documentCaptureOverlayViewControllerDidCaptureHighResolutionImage:(nonnull MBINDocumentCaptureOverlayViewController *)documentCaptureOverlayViewController highResImage:(MBINImage *)highResImage state:(MBINRecognizerResultState)state;

@end

NS_ASSUME_NONNULL_END
