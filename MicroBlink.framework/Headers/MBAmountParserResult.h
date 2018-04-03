//
//  MBAmountParserResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBAmountParser is used for extracting amount from OCR result
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBAmountParserResult : MBParserResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the recognized amount number or empty string if recognition failed.
 */
@property (nonatomic, nullable, strong, readonly) NSString *amount;

@end

NS_ASSUME_NONNULL_END
