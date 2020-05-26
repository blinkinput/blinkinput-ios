//
//  MBDocumentCaptureRecognizer.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 15/01/2020.
//

#import "MBRecognizer.h"
#import "MBDocumentCaptureRecognizerResult.h"

#import "MBFullDocumentImage.h"
#import "MBEncodeFullDocumentImage.h"
#import "MBFullDocumentImageExtensionFactors.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer for DocumentCaptureRecognizer
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBDocumentCaptureRecognizer : MBRecognizer<NSCopying, MBFullDocumentImage, MBEncodeFullDocumentImage, MBFullDocumentImageExtensionFactors>

MB_INIT

/**
 * DocumentCaptureRecognizer recognizer results
 */
@property (nonatomic, strong, readonly) MBDocumentCaptureRecognizerResult *result;

/**
 * Defines how many times the same document should be detected before the detector
 * returns this document as a result of the deteciton
 *
 * Higher number means more reliable detection, but slower processing
 *
 * Default: 3
 */
@property (nonatomic, assign) NSUInteger numStableDetectionsThreshold;

/**
 * Defines minimum document scale calculated as ratio of minimal document dimension and minimal dimension of the input image.
 *
 * Default: 0.5
 */
@property (nonatomic, assign) CGFloat minDocumentScale;

@end

NS_ASSUME_NONNULL_END
