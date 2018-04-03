//
//  MBRegexParserResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 15/03/2018.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBDateParser that can extract date from OCR result.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBRegexParserResult : MBParserResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns string containing parsed OCR result according to given regular expression.
 */
@property (nonatomic, strong, readonly) NSString *parsedString;

@end

NS_ASSUME_NONNULL_END