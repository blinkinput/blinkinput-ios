//
//  MBParserGroupProcessor.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 02/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBProcessor.h"
#import "MBParserGroupProcessorResult.h"
#import "MBMicroblinkDefines.h"
#import "MBMicroblinkInitialization.h"

@class MBIParser;

NS_ASSUME_NONNULL_BEGIN

/**
 * A processor for a group
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIParserGroupProcessor : MBIProcessor <NSCopying>

MB_INIT_UNAVAILABLE

- (instancetype)initWithParsers:(NSArray<MBIParser *> *)parsers NS_DESIGNATED_INITIALIZER;

/**
 * Getting array of readonly parsers
 */
@property (nonatomic, strong, readonly) NSArray<MBIParser *> *parsers;

/**
 * MBIParserGroupProcessor processor result
 */
@property (nonatomic, strong, readonly) MBIParserGroupProcessorResult *result;

/**
 * Set if one optional element should be valid
 *
 * DEFAULT: NO
 */
@property (nonatomic, assign) BOOL oneOptionalElementInGroupShouldBeValid;

@end

NS_ASSUME_NONNULL_END
