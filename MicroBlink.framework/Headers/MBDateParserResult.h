//
//  MBDateParserResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 12/03/2018.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBDateParser that can extract date from OCR result.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBDateParserResult : MBParserResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Extracted date.
 */
@property (nonatomic, strong, readonly) NSDate *date;

/**
 * Extracted date string.
 */
@property (nonatomic, strong, readonly) NSString *rawDate;

@end

NS_ASSUME_NONNULL_END
