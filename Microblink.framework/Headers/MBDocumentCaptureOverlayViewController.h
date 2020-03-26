//
//  MBDocumentCaptureOverlayViewController.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 13/01/2020.
//

#import "MBBaseOverlayViewController.h"
#import "MBDocumentCaptureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBDocumentCaptureOverlayViewControllerDelegate;

@class MBDocumentCaptureOverlaySettings;

/**
 * Default version of overlay view controller with modern design.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBDocumentCaptureOverlayViewController : MBBaseOverlayViewController

/**
 * Common Document Capture UI settings
 */
@property (nonatomic, readonly) MBDocumentCaptureOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBDocumentCaptureOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBDocumentCaptureOverlaySettings object
 *
 *  @param documentCaptureRecognizer MBDocumentCaptureRecognizer object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBDocumentCaptureOverlaySettings *)settings recognizer:(MBDocumentCaptureRecognizer *)documentCaptureRecognizer delegate:(nonnull id<MBDocumentCaptureOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
