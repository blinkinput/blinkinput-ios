//
//  MBDocumentCaptureRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 15/01/2020.
//

#import "MBRecognizerResult.h"

#import "MBFullDocumentImageResult.h"
#import "MBEncodedFullDocumentImageResult.h"
#import "MBQuadrangle.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Class representing values obtained when capturing document
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBDocumentCaptureRecognizerResult : MBRecognizerResult<NSCopying, MBFullDocumentImageResult, MBEncodedFullDocumentImageResult>

MB_INIT_UNAVAILABLE

/**
 * Quadrangle represeting corner points of location of the captured document
 */
@property (nonatomic, readonly) MBQuadrangle *detectionLocation;

@end

NS_ASSUME_NONNULL_END
