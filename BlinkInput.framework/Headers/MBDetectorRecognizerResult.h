//
//  MBDetectorRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBTemplatingRecognizerResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Result of MBINDetectorRecognizer
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINDetectorRecognizerResult : MBINTemplatingRecognizerResult<NSCopying>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
