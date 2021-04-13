//
//  MBQuadWithSizeDetectorResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 20/03/2018.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBDetectorResult.h"
#import "MBQuadrangle.h"
#import "MBQuadDetectorResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all detectors  that are used for MBIQuadrangle
 * detection and can also provide physical size of the detected document.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBIQuadWithSizeDetectorResult : MBIQuadDetectorResult <NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Returns the physical height of the detected MBIQuadrangle in inches.
 */
@property (nonatomic, assign, readonly) CGFloat physicalHeightInInches;

@end

NS_ASSUME_NONNULL_END
