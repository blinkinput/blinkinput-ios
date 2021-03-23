//
//  MBDetectorRecognizer.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBTemplatingRecognizer.h"
#import "MBDetectorRecognizerResult.h"
#import "MBMicroblinkInitialization.h"

@class MBINQuadWithSizeDetector;

NS_ASSUME_NONNULL_BEGIN

/**
 * Recognizer for scanning generic documents using custom MBINDetector.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINDetectorRecognizer : MBINTemplatingRecognizer<NSCopying>

MB_INIT_UNAVAILABLE

- (instancetype)initWithQuadWithSizeDetector:(MBINQuadWithSizeDetector *)detector NS_DESIGNATED_INITIALIZER;

/**
 * Detector recognizer results
 */
@property (nonatomic, strong, readonly) MBINDetectorRecognizerResult *result;

/**
 * Set this to true to enable recognition of document also in upside down direction.
 * This is useful if detector being used cannot determine correct orientation of detected
 * document (for example MBINDocumentDetector).
 * Keep in mind that enabling this feature will make recognition two times slower
 * and possibly less accurate. By default, this is turned off.
 *
 * Default: NO
 */
@property (nonatomic, assign) BOOL allowFlipped;

/**
 * Returns the detector that will be used for performing the document detection during recognition
 */
@property (nonatomic, strong, readonly) MBINQuadWithSizeDetector *detector;

@end

NS_ASSUME_NONNULL_END
