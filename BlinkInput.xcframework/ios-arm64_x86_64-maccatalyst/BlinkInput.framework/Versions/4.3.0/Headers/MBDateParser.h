//
//  MBDateParser.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 12/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBParser.h"
#import "MBDateParserResult.h"
#import "MBMicroblinkInitialization.h"

/**
 * Available date formats for date parser. To activate parsing of dates with month names in
 * English, use formats which contain MONTH, e.g. MBINDateFormatDDMONTHYYYY.
 * Month names in uppercase and short month names are supported (for example March and Mar).
 */
typedef NS_ENUM(NSInteger, MBINDateFormat) {
    MBINDateFormatDDMMYYYY = 0,
    MBINDateFormatDDMMYY,
    MBINDateFormatMMDDYYYY,
    MBINDateFormatMMDDYY,
    MBINDateFormatYYYYMMDD,
    MBINDateFormatYYMMDD,
    MBINDateFormatDDMONTHYYYY,
    MBINDateFormatDDMONTHYY,
    MBINDateFormatMONTHDDYYYY,
    MBINDateFormatMONTHDDYY,
    MBINDateFormatYYYYMONTHDD,
    MBINDateFormatYYMONTHDD
};

typedef NSArray<NSNumber *> MBINDateFormatArray;
typedef NSArray<NSString *> MBINDateSeparatorCharsArray;

NS_ASSUME_NONNULL_BEGIN

/**
 * MBINDateParser that can extract date from OCR result.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINDateParser : MBINParser <NSCopying>

MB_INIT

/**
 * Date parser result
 */
@property (nonatomic, strong, readonly) MBINDateParserResult *result;

/**
 * Specifies the date formats that will be accepted by date parser. By default, all available
 * numeric date formats from MBINDateFormat enum will be accepted (all formats in which month
 * is numeric).
 * Array of expected date formats, if it is nil or empty, date formats will be set to default value.
 */
- (void)setDateFormats:(nonnull MBINDateFormatArray *)dateFormats;

/**
 * Specifies the date separator characters between date parts (day, month, year) that will be
 * accepted by date parser. By default, separator characters are: '.', '/' and '-'.
 * If it is nil or empty, date separator characters will be use default value.
 */
- (void)setDateSeparatorChars:(nonnull MBINDateSeparatorCharsArray *)dateSeparatorChars;

@end

NS_ASSUME_NONNULL_END
