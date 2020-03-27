//
//  MBDocumentCaptureSubview.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 16/01/2020.
//

#import "MBSubview.h"
#import "MBQuadDetectorSubview.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Overlay subview presenting the status of detection.
 * The subview is presented as rectangle view over document
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBDocumentCaptureSubview : MBSubview <MBQuadDetectorSubview>

/**
 * Resets the document capture subview to it's initial position
 */
- (void)resetPositions;

/**
* Background color of document capture detection view
*/
@property (nonatomic, strong) UIColor *backgroundColor;

/**
* Border color of document capture detection view
* Default: white
*/
@property (nonatomic, strong) UIColor *borderColor;

/**
* Opacity of document capture detection view
* Default: 0.75
*/
@property (nonatomic, assign) CGFloat alphaOpacity;

@end

NS_ASSUME_NONNULL_END
