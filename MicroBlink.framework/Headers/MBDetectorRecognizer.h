//
//  MBDetectorRecognizer.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBTemplatingRecognizer.h"
#import "MBDetectorRecognizerResult.h"
#import "MBMicroBlinkInitialization.h"

@class MBDetector;

NS_ASSUME_NONNULL_BEGIN

/**
 * Recognizer for scanning generic documents using custom MBDetector.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBDetectorRecognizer : MBTemplatingRecognizer<NSCopying>

MB_INIT_UNAVAILABLE

- (instancetype)initWithDetector:(MBDetector *)detector NS_DESIGNATED_INITIALIZER;

/**
 * Detector recognizer results
 */
@property (nonatomic, strong, readonly) MBDetectorRecognizerResult *result;

/**
 * Set this to true to enable recognition of document also in upside down direction.
 * This is useful if detector being used cannot determine correct orientation of detected
 * document (for example MBDocumentDetector).
 * Keep in mind that enabling this feature will make recognition two times slower
 * and possibly less accurate. By default, this is turned off.
 *
 * Default: NO
 */
@property (nonatomic, assign) BOOL allowFlipped;

/**
 * Returns the detector that will be used for performing the document detection during recognition
 */
@property (nonatomic, strong, readonly) MBDetector *detector;

@end

NS_ASSUME_NONNULL_END
