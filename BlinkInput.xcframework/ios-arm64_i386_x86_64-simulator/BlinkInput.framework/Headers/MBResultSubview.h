//
//  MBResultSubview.h
//  MicroblinkDev
//
//  Created by Dino Gustin on 02/05/2018.
//

#import "MBRecognizerResult.h"

/**
 * Protocol for processing MBIRecognizerResult. Subviews implementing this protocol process and draw result data on the screen (e.g. letting users know is scanning was successful)
 */
@protocol MBIResultSubview <NSObject>

/**
 * This method should be called when MBIRecognizerResultState is obtained and reslt state need to be drawn/redrawn.
 */
- (void)scanningFinishedWithState:(MBIRecognizerResultState)state;

@end
