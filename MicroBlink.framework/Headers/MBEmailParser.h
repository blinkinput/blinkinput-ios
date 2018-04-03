//
//  MBEmailParser.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBParser.h"
#import "MBEmailParserResult.h"
#import "MBMicroBlinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBEmailParser is used for parsing emails
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBEmailParser : MBParser <NSCopying>

/**
 * Email parser result
 */
@property (nonatomic, strong, readonly) MBEmailParserResult *result;

@end

NS_ASSUME_NONNULL_END
