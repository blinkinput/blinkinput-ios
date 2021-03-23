//
//  MBDocumentCaptureOverlayViewController.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 13/01/2020.
//

#import "MBBaseOverlayViewController.h"
#import "MBDocumentCaptureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBINDocumentCaptureOverlayViewControllerDelegate;

@class MBINDocumentCaptureOverlaySettings;

/**
 * Default version of overlay view controller with modern design.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINDocumentCaptureOverlayViewController : MBINBaseOverlayViewController

/**
 * Common Document Capture UI settings
 */
@property (nonatomic, readonly) MBINDocumentCaptureOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBINDocumentCaptureOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBINDocumentCaptureOverlaySettings object
 *
 *  @param documentCaptureRecognizer MBINDocumentCaptureRecognizer object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBINDocumentCaptureOverlaySettings *)settings recognizer:(MBINDocumentCaptureRecognizer *)documentCaptureRecognizer delegate:(nonnull id<MBINDocumentCaptureOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
