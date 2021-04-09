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
@interface MBIRecognizerRunnerMetadataDelegates : NSObject
 
@property (nonatomic, weak, nullable) id<MBIDebugRecognizerRunnerDelegate> debugRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBIDetectionRecognizerRunnerDelegate> detectionRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBIOcrRecognizerRunnerDelegate> ocrRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBIGlareRecognizerRunnerDelegate> glareRecognizerRunnerDelegate;
 
@end
 