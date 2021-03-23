//
//  MBPointDetectorSubview.h
//  MicroblinkDev
//
//  Created by Dino Gustin on 02/05/2018.
//

#import "MBDisplayablePointsDetection.h"

/**
 * Protocol for processing MBINDisplayablePointsDetection. Subviews implementing this protocol process and draw points on the screen (e.g. flashing dots)
 */
@protocol MBINPointDetectorSubview <NSObject>

/**
 * This method should be called when MBINDisplayablePointsDetection is obtained and points need to be drawn/redrawn.
 */
- (void)detectionFinishedWithDisplayablePoints:(MBINDisplayablePointsDetection *)displayablePointsDetection;

@end
