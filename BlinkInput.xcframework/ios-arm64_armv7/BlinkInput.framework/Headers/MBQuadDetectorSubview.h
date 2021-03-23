//
//  MBQuadDetectorSubview.h
//  MicroblinkDev
//
//  Created by Dino Gustin on 02/05/2018.
//

#import "MBDisplayableQuadDetection.h"

/**
 * Protocol for processing MBINDisplayableQuadDetection. Subviews implementing this protocol process and draw quad on the screen (e.g. viewfinder drawing document outlining)
 */
@protocol MBINQuadDetectorSubview <NSObject>

/**
 * This method should be called when MBINDisplayableQuadDetection is obtained and quad need to be drawn/redrawn.
 */
- (void)detectionFinishedWithDisplayableQuad:(MBINDisplayableQuadDetection *)displayableQuadDetection;

@end
