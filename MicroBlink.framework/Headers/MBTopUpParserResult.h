//
//  MBTopUpParserResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBTopUpParser is used for parsing Top Up numbers
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBTopUpParserResult : MBParserResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the recognized Top Up number or empty string if recognition failed.
 */
@property (nonatomic, nullable, strong, readonly) NSString *topUp;

@end

NS_ASSUME_NONNULL_END
