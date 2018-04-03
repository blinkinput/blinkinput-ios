//
//  MBVinParser.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 07/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBParser.h"
#import "MBVinParserResult.h"
#import "MBMicroBlinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBVinParser is used for parsing VIN numbers
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBVinParser : MBParser <NSCopying>

MB_INIT

/**
 * Vin parser result
 */
@property (nonatomic, strong, readonly) MBVinParserResult *result;

@end

NS_ASSUME_NONNULL_END
