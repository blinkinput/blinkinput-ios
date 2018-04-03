//
//  MBSuccessFrameGrabberRecognizerResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 22/12/2017.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBRecognizerResult.h"

@class MBImage;

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that returns SuccessFrameGrabber result.
 */
PP_CLASS_AVAILABLE_IOS(8.0)

@interface MBSuccessFrameGrabberRecognizerResult : MBRecognizerResult<NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Success frame PPImage of successful frame
 */
@property (nonatomic, strong, readonly) MBImage *successFrame;

@end

NS_ASSUME_NONNULL_END
