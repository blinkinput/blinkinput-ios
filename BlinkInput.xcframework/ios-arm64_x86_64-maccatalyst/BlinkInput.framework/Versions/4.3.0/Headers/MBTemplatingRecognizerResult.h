//
//  MBTemplatingRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBRecognizerResult.h"

@class MBINTemplatingClass;

NS_ASSUME_NONNULL_BEGIN

/**
 * Base of all recognizers result that support Templating API.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINTemplatingRecognizerResult : MBINRecognizerResult

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the MBINTemplatingClass for recognized document. If classification failed,
 * returns nil.
 */
@property (nonatomic, nullable, strong, readonly) MBINTemplatingClass *templatingClass;

@end

NS_ASSUME_NONNULL_END

