//
//  MBCustomOverlayViewController.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 25/04/2018.
//

#import "MBOverlayViewController.h"
#import "MBMicroBlinkInitialization.h"

#import "MBBaseOverlaySettings.h"
#import "MBRecognizerRunnerViewControllerMetadataDelegates.h"
#import "MBScanningRecognizerRunnerViewControllerDelegate.h"
#import "MBRecognizerRunnerViewControllerDelegate.h"

@class MBRecognizerCollection;
@class MBCameraSettings;

NS_ASSUME_NONNULL_BEGIN

/**
 Custom Overlay View Controller is an abstract class for all custom overlay views placed on top View Controller.
 It's responsibility is to provide meaningful and useful interface for the user to interact with.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBCustomOverlayViewController : MBOverlayViewController

@property (nonatomic, readonly, strong) MBRecognizerCollection *recognizerCollection;
@property (nonatomic, readonly, strong) MBBaseOverlaySettings *settings;
@property (nonatomic, strong) MBRecognizerRunnerViewControllerMetadataDelegates *metadataDelegates;
@property (nonatomic, weak) id<MBScanningRecognizerRunnerViewControllerDelegate> scanningRecognizerRunnerViewControllerDelegate;
@property (nonatomic, weak) id<MBRecognizerRunnerViewControllerDelegate> recognizerRunnerViewControllerDelegate;

/**
 * Convenience initializer used for use cases when overlay view controller is instantiated from storyboard.
 * It creates default MBCameraSettings and empty MBRecognizerCollection. To add recognizers after this
 * initializer is used, please use reconfigureRecognizers:.
 */
- (instancetype)init;

- (instancetype)initWithRecognizerCollection:(MBRecognizerCollection *)recognizerCollection overlaySettings:(MBBaseOverlaySettings *)overlaySettings NS_DESIGNATED_INITIALIZER;

- (void)reconfigureRecognizers:(MBRecognizerCollection *)recognizerCollection;

- (void)applySettings:(MBBaseOverlaySettings *)settings;

@end

NS_ASSUME_NONNULL_END
