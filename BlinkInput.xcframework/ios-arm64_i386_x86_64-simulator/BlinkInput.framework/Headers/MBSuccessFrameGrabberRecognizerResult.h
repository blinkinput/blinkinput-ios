//
//  MBSuccessFrameGrabberRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/12/2017.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBRecognizerResult.h"

@class MBINImage;

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that returns SuccessFrameGrabber result.
 */
MB_CLASS_AVAILABLE_IOS(8.0)

@interface MBINSuccessFrameGrabberRecognizerResult : MBINRecognizerResult<NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Success frame MBINImage of successful frame
 */
@property (nonatomic, strong, readonly) MBINImage *successFrame;

@end

NS_ASSUME_NONNULL_END
