//
//  MBProcessorResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 02/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"

/**
 * Enumeration of posibble processor result state
 */
typedef NS_ENUM(NSInteger, MBINProcessorResultState) {
    
    /**
     *  Empty
     */
    MBINProcessorResultStateEmpty,
    
    /**
     *  Uncertain
     */
    MBINProcessorResultStateUncertain,
    
    /**
     *  Valid
     */
    MBINProcessorResultStateValid,
    
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all processor results
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINProcessorResult : NSObject

MB_INIT_UNAVAILABLE

@property (nonatomic, assign, readonly) MBINProcessorResultState resultState;

@end

NS_ASSUME_NONNULL_END

