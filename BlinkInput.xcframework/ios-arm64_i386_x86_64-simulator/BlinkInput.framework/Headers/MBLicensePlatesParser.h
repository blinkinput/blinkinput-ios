//
//  MBLicensePlatesParser.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBParser.h"
#import "MBLicensePlatesParserResult.h"
#import "MBMicroblinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBINLicensePlatesParser is used for parsing license plates
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINLicensePlatesParser : MBINParser <NSCopying>

MB_INIT

/**
 * License plates parser result
 */
@property (nonatomic, strong, readonly) MBINLicensePlatesParserResult *result;

@end

NS_ASSUME_NONNULL_END
