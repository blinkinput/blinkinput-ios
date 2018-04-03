//
//  MBRecognizerRunnerMetadataDelegates.h
//  Pdf417MobiDev
//
//  Created by Jura Skrlec on 09/02/2018.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"

@protocol MBDetectionRecognizerRunnerDelegate;
@protocol MBDebugRecognizerRunnerDelegate;
@protocol MBOcrRecognizerRunnerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 * Class containing all metadata delegates
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBRecognizerRunnerMetadataDelegates : NSObject

@property (nonatomic, weak) id<MBDebugRecognizerRunnerDelegate> debugRecognizerRunnerDelegate;
@property (nonatomic, weak) id<MBDetectionRecognizerRunnerDelegate> detectionRecognizerRunnerDelegate;
@property (nonatomic, weak) id<MBOcrRecognizerRunnerDelegate> ocrRecognizerRunnerDelegate;

@end

NS_ASSUME_NONNULL_END

