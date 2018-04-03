//
//  MBRecognizer.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 21/11/2017.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBEntity.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all recognizers
 */
PP_CLASS_AVAILABLE_IOS(6.0)
@interface MBRecognizer : MBEntity

/**
 * Property which determines if the recognizer is enabled
 *
 *  If YES, recognizer is enabled, and it peroforms recognition on each video frame.
 *
 * Default: YES
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;

- (UIInterfaceOrientationMask)getOptimalHudOrientation;

@end

NS_ASSUME_NONNULL_END
