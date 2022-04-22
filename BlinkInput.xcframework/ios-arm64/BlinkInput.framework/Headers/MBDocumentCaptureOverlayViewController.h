//
//  MBDocumentCaptureOverlayViewController.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 13/01/2020.
//

#import "MBBaseOverlayViewController.h"
#import "MBDocumentCaptureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBIDocumentCaptureOverlayViewControllerDelegate;

@class MBIDocumentCaptureOverlaySettings;

/**
 * Default version of overlay view controller with modern design.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIDocumentCaptureOverlayViewController : MBIBaseOverlayViewController

/**
 * Common Document Capture UI settings
 */
@property (nonatomic, readonly) MBIDocumentCaptureOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBIDocumentCaptureOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBIDocumentCaptureOverlaySettings object
 *
 *  @param documentCaptureRecognizer MBIDocumentCaptureRecognizer object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBIDocumentCaptureOverlaySettings *)settings recognizer:(MBIDocumentCaptureRecognizer *)documentCaptureRecognizer delegate:(nonnull id<MBIDocumentCaptureOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
