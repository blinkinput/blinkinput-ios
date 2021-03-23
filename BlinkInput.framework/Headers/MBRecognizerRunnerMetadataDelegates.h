// 
// MBRecognizerRunnerMetadataDelegates.h
// 
// AUTOMATICALLY GENERATED SOURCE. DO NOT EDIT!
// 
 
#import "MBDebugRecognizerRunnerDelegate.h"
#import "MBDetectionRecognizerRunnerDelegate.h"
#import "MBOcrRecognizerRunnerDelegate.h"
#import "MBGlareRecognizerRunnerDelegate.h"
 
#import "MBMicroblinkDefines.h"
#import <Foundation/Foundation.h>
 
/**
 * Class containing all metadata delegates
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINRecognizerRunnerMetadataDelegates : NSObject
 
@property (nonatomic, weak, nullable) id<MBINDebugRecognizerRunnerDelegate> debugRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBINDetectionRecognizerRunnerDelegate> detectionRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBINOcrRecognizerRunnerDelegate> ocrRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBINGlareRecognizerRunnerDelegate> glareRecognizerRunnerDelegate;
 
@end
 