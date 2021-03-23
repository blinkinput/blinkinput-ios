//
//  MBDateParserResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 12/03/2018.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBParserResult.h"
#import "MBDateResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBINDateParser that can extract date from OCR result.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINDateParserResult : MBINParserResult <NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Extracted date.
 */
@property (nonatomic, strong, readonly) MBINDateResult *date;

@end

NS_ASSUME_NONNULL_END
