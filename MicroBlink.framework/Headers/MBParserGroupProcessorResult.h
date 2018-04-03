//
//  MBParserGroupProcessorResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 02/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBProcessorResult.h"
#import "MBOcrLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that can scan PDF417 2D barcodes.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBParserGroupProcessorResult : MBProcessorResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) MBOcrLayout *ocrLayout;

@end

NS_ASSUME_NONNULL_END
