//
//  MBProcessorResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 02/03/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"

/**
 * Enumeration of posibble processor result state
 */
typedef NS_ENUM(NSUInteger, MBProcessorResultState) {
    
    /**
     *  Empty
     */
    MBProcessorResultStateEmpty,
    
    /**
     *  Uncertain
     */
    MBProcessorResultStateUncertain,
    
    /**
     *  Valid
     */
    MBProcessorResultStateValid,
    
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all processor results
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBProcessorResult : NSObject

@property (nonatomic, assign, readonly) MBProcessorResultState resultState;

@end

NS_ASSUME_NONNULL_END

