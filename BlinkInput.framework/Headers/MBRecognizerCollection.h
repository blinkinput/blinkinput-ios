//
//  MBScanSettings.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 24/11/2017.
//

#import <Foundation/Foundation.h>

#import "MBRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Denotes the mode in which Recognizers performs recognition
 */
typedef NS_ENUM(NSInteger, MBINRecognitionDebugMode) {
    
    /** Classic, production mode. Results are returned after first valid scanning */
    MBINRecognitionDebugModeDefault,
    
    /** Recognition Test. Results are never returned, recognition is performed repeatedly */
    MBINRecognitionDebugModeTest,
    
    /** Recognition Test. Results are never returned, only detection is performed repeatedly */
    MBINRecognitionDebugModeDetectionTest
};

/**
 *  Denotes the mode in which FrameQuality estimation works
 */
typedef NS_ENUM(NSInteger, MBINFrameQualityEstimationMode) {
    
    /** Default. Frame quality estimation is ON if enabled recognizers require it by default.*/
    MBINFrameQualityEstimationModeDefault,
    
    /** Frame quality estimation is always on */
    MBINFrameQualityEstimationModeOn,
    
    /** Frame quality estimation is always off */
    MBINFrameQualityEstimationModeOff
};

/**
 * Settings class containing settings related to scanner behaviour
 */
MB_CLASS_AVAILABLE_IOS(8.0)

@interface MBINRecognizerCollection : NSObject<NSCopying>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithRecognizers:(NSArray<MBINRecognizer *> *)recognizers NS_DESIGNATED_INITIALIZER;

/**
 * Contains MBINRecognizer objects - each individual recognizer.
 * On each video frame taken by device scamera, processing is performed by a series of recognizers.
 * Ordering of these recognizers is specified by this array.
 *
 * @see MBINRecognizer.
 */
@property (nonatomic, strong) NSArray<MBINRecognizer *> *recognizerList;


/**
 * If NO, recognizer chain will stop when finds first valid scan results and will return just it.
 * If YES, recognizer chain can sometimes return more than one scanning result.
 *
 * Default: YES
 */
@property (nonatomic) BOOL allowMultipleResults;

/**
 * Timeout interval in which the partial scanning results will be returned to the user.
 * If <= 0.0, no timeout event will be reported.
 *
 * Default: 0 seconds, which means no timeout will be reported.
 */
@property (nonatomic) NSTimeInterval partialRecognitionTimeout;

/**
 * Recognition debug mode.
 *
 * This method is for debugging and testing purposes only. Please do not use it because calling it with
 * wrong parameter might cause scanning loop to never terminate.
 *
 * Default: MBINRecognitionDebugModeDefault
 */
@property (nonatomic) MBINRecognitionDebugMode recognitionDebugMode;

/**
 * Frame quality estimation mode. If frame quality estimation is on, some video frames will be skipped, if
 * frame quality estimator determines the quality is too low (i.e. frame is too blurry, too dark, or something similar).
 *
 * The downside is that frame quality estimation spends some valuable CPU time.
 *
 * Default MBINFrameQualityEstimationModeDefault
 */
@property (nonatomic) MBINFrameQualityEstimationMode frameQualityEstimationMode;

@end

NS_ASSUME_NONNULL_END
