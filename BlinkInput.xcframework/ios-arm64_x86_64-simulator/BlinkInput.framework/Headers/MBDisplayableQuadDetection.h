//
//  MBDisplayableQuadDetection.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 08/12/2017.
//

#import "MBDisplayableDetection.h"
#import "MBQuadrangle.h"

#import "MBMicroblinkDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents a detection that can be displayed on screen.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBIDisplayableQuadDetection : MBIDisplayableDetection

/**
 * Exact location of detected object on image.
 * Contains 4 points of detected object's corners.
 */
@property (nonatomic, strong) MBIQuadrangle *detectionLocation;

@end

NS_ASSUME_NONNULL_END
