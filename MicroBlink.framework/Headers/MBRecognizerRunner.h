//
//  MBRecognizerRunnerView.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 20/12/2017.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBRecognizerRunnerMetadataDelegates.h"

@protocol MBDetectionRecognizerRunnerDelegate;
@protocol MBOcrRecognizerRunnerDelegate;
@protocol MBScanningRecognizerRunnerDelegate;
@protocol MBDebugRecognizerRunnerDelegate;

@class MBSettings;
@class MBCoordinator;
@class MBImage;

NS_ASSUME_NONNULL_BEGIN

/**
 * Factory class containing static methods for creating camera view controllers.
 * Camera view controllers created this way will be managed internally by the SDK, and input frames will be processed.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBRecognizerRunner : NSObject

@property (nonatomic, strong) MBRecognizerRunnerMetadataDelegates *metadataDelegates;
@property (nonatomic, weak) id<MBScanningRecognizerRunnerDelegate> scanningRecognizerRunnerDelegate;

@property (nonatomic, nullable) MBCoordinator *coordinator;

- (instancetype)init NS_UNAVAILABLE;

/** Initializes the recognizer runner */
- (instancetype)initWithSettings:(MBSettings *)settings NS_DESIGNATED_INITIALIZER;

- (void)resetState;

- (void)resetState:(BOOL)hard;

/**
 * Processes a PPImage object synchronously using current settings.
 * Since this method is synchronous, calling it from a main thread will switch the call to alternate thread internally and output a warning.
 *
 * Results are passed a delegate object given upon a creation of PPCoordinator.
 *
 *  @param image            image for processing
 */
- (void)processImage:(MBImage *)image;

/**
 * Method which is used to apply MBSettings object given by currentSettings property
 *
 * Usual use case is to update settings on the fly, to perform some complex scanning functionality
 * where a reconfiguration of the recognizers is needed.
 */
- (void)applySettings:(MBSettings *)newSettings;

- (MBSettings *)getSettings;

@end

NS_ASSUME_NONNULL_END
