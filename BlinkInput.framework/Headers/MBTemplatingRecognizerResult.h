//
//  MBTemplatingRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBRecognizerResult.h"

@class MBITemplatingClass;

NS_ASSUME_NONNULL_BEGIN

/**
 * Base of all recognizers result that support Templating API.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBITemplatingRecognizerResult : MBIRecognizerResult

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the MBITemplatingClass for recognized document. If classification failed,
 * returns nil.
 */
@property (nonatomic, nullable, strong, readonly) MBITemplatingClass *templatingClass;

@end

NS_ASSUME_NONNULL_END

