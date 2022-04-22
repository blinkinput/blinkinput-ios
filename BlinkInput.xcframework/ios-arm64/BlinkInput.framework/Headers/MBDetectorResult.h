//
//  MBDetectorResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 19/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBDetectionStatus.h"

/**
 * Enum for type of detection status.
 */
typedef NS_ENUM(NSInteger, MBIDetectionCode) {
    /**
     * Object detection has failed.
     */
    MBIDetectionCodeFail = 0,
    
    /**
     * Object was detected partially. Only some PhotoPay detectors support this.
     */
    MBIDetectionCodeFallback,
    
    /**
     * Object detection has succeded.
     */
    MBIDetectionCodeSuccess,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all detectors results
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBIDetectorResult : NSObject

@property (nonatomic, assign, readonly) MBIDetectionCode detectionCode;
@property (nonatomic, assign, readonly) MBIDetectionStatus detectionStatus;

@end

NS_ASSUME_NONNULL_END

