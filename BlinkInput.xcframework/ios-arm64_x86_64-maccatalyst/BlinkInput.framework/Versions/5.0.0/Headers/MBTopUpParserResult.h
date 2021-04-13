//
//  MBTopUpParserResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBParserResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBITopUpParser is used for parsing Top Up numbers
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBITopUpParserResult : MBIParserResult <NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Returns the recognized Top Up number or empty string if recognition failed.
 */
@property (nonatomic, nullable, strong, readonly) NSString *topUp;

@end

NS_ASSUME_NONNULL_END
