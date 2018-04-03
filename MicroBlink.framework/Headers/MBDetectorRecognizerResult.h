//
//  MBDetectorRecognizerResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBTemplatingRecognizerResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Result of MBDetectorRecognizer
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBDetectorRecognizerResult : MBTemplatingRecognizerResult<NSCopying>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
