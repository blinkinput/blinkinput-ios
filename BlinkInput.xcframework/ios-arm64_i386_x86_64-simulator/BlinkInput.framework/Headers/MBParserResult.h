//
//  MBParserResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 06/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"

/**
 * Enumeration of posibble parser result state
 */
typedef NS_ENUM(NSInteger, MBINParserResultState) {
    
    /**
     *  Empty
     */
    MBINParserResultStateEmpty,
    
    /**
     *  Uncertain
     */
    MBINParserResultStateUncertain,
    
    /**
     *  Valid
     */
    MBINParserResultStateValid,
    
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all parser results
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINParserResult : NSObject

MB_INIT_UNAVAILABLE

@property (nonatomic, assign, readonly) MBINParserResultState resultState;

@end

NS_ASSUME_NONNULL_END
