//
//  MBLicensePlatesParserResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBLicensePlatesParser is used for parsing license plates
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBLicensePlatesParserResult : MBParserResult <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the recognized license plate number or empty string if recognition failed.
 */
@property (nonatomic, nullable, strong, readonly) NSString *licensePlate;

@end

NS_ASSUME_NONNULL_END
