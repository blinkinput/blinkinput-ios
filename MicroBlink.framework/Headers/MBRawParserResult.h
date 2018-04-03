//
//  MBRawParserResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 14/03/2018.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBDateParser that can extract date from OCR result.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBRawParserResult : MBParserResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Extracted date string.
 */
@property (nonatomic, strong, readonly) NSString *rawText;

@end

NS_ASSUME_NONNULL_END
