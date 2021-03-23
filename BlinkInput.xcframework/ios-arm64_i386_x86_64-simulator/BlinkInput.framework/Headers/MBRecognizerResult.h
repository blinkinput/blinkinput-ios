//
//  MBRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/11/2017.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"

/**
 * Enumeration of posibble recognizer result state
 */
typedef NS_ENUM(NSInteger, MBINRecognizerResultState) {
    
    /**
     *  Empty
     */
    MBINRecognizerResultStateEmpty,
    
    /**
     *  Uncertain
     */
    MBINRecognizerResultStateUncertain,
    
    /**
     *  Valid
     */
    MBINRecognizerResultStateValid,

    /**
     *  StageValid
     */
    MBINRecognizerResultStateStageValid,

};

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all recognizer results
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINRecognizerResult : NSObject

MB_INIT_UNAVAILABLE

@property (nonatomic, assign, readonly) MBINRecognizerResultState resultState;
@property (nonatomic, readonly) NSString *resultStateString;

@end

NS_ASSUME_NONNULL_END
