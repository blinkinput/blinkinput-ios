//
//  MBMrtdDetectorResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 20/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBQuadWithSizeDetectorResult.h"
#import "MBQuadrangle.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Detector that can perform detection of Machine Readable Travel Documents (MRTD).
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBMrtdDetectorResult : MBQuadWithSizeDetectorResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the location of Machine Readable Zone in coordinate system of image in which detection was performed.
 */
@property (nonatomic, nullable, strong, readonly) MBQuadrangle *mrzLocation;

/**
 * Returns the physical height in inches of Machine Readable Zone.
 */
@property (nonatomic, assign, readonly) CGFloat mrzPhysicalHeightInInches;

@end

NS_ASSUME_NONNULL_END

