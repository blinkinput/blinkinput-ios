//
//  MBImageReturnProcessor.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 23/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBProcessor.h"
#import "MBImageReturnProcessorResult.h"
#import "MBMicroblinkDefines.h"
#import "MBMicroblinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Processor that will simply save given image.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINImageReturnProcessor : MBINProcessor <NSCopying>

MB_INIT

/**
 * MBINImageReturnProcessor processor result
 */
@property (nonatomic, strong, readonly) MBINImageReturnProcessorResult *result;

/**
 * Defines whether saved image will also be encoded as JPEG. This is false by default, which
 * means that only original image will be saved.
 *
 * Default: NO
 */
@property (nonatomic, assign) BOOL encodeImage;

@end

NS_ASSUME_NONNULL_END
