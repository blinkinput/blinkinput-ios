//
//  MBDocumentDetector.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 20/03/2018.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBQuadWithSizeDetector.h"
#import "MBDocumentDetectorResult.h"
#import "MBMicroBlinkInitialization.h"
#import "MBDocumentSpecification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Detector that can perform detection of card documents, cheques, papers, etc.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBDocumentDetector : MBQuadWithSizeDetector <NSCopying>

MB_INIT

/**
 * Document detector result
 */
@property (nonatomic, strong, readonly) MBDocumentDetectorResult *result;

/**
 * Defines how many times the same document should be detected before the detector
 * returns this document as a result of the deteciton
 *
 * Higher number means more reliable detection, but slower processing
 */
@property (nonatomic, assign) NSUInteger numStableDetectionsThreshold;

/**
 * Sets the document specifications. Document specifications describe the images that should be returned by
 * the detectior.
 *
 *  @param documentSpecifications document specifications
 */
- (void)setDocumentSpecifications:(NSArray<__kindof MBDocumentSpecification *> *)documentSpecifications;

@end

NS_ASSUME_NONNULL_END
