//
//  MBRawParserResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 14/03/2018.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBIDateParser that can extract date from OCR result.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBIRawParserResult : MBIParserResult <NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Extracted date string.
 */
@property (nonatomic, strong, readonly) NSString *rawText;

@end

NS_ASSUME_NONNULL_END
