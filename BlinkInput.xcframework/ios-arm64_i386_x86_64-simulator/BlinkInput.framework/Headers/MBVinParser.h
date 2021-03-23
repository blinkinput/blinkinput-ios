//
//  MBVinParser.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 07/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBParser.h"
#import "MBVinParserResult.h"
#import "MBMicroblinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBINVinParser is used for parsing VIN numbers
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINVinParser : MBINParser <NSCopying>

MB_INIT

/**
 * Vin parser result
 */
@property (nonatomic, strong, readonly) MBINVinParserResult *result;

@end

NS_ASSUME_NONNULL_END
