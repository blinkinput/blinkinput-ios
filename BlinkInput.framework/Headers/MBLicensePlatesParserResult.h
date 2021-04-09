//
//  MBLicensePlatesParserResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBILicensePlatesParser is used for parsing license plates
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBILicensePlatesParserResult : MBIParserResult <NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Returns the recognized license plate number or empty string if recognition failed.
 */
@property (nonatomic, nullable, strong, readonly) NSString *licensePlate;

@end

NS_ASSUME_NONNULL_END
