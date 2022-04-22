//
//  MBEmailParser.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 09/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBParser.h"
#import "MBEmailParserResult.h"
#import "MBMicroblinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MBIEmailParser is used for parsing emails
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIEmailParser : MBIParser <NSCopying>

/**
 * Email parser result
 */
@property (nonatomic, strong, readonly) MBIEmailParserResult *result;

@end

NS_ASSUME_NONNULL_END
