// 
// MBRecognizerRunnerViewControllerMetadataDelegates.h
// 
// AUTOMATICALLY GENERATED SOURCE. DO NOT EDIT!
// 
 
#import "MBDebugRecognizerRunnerViewControllerDelegate.h"
#import "MBDetectionRecognizerRunnerViewControllerDelegate.h"
#import "MBOcrRecognizerRunnerViewControllerDelegate.h"
#import "MBGlareRecognizerRunnerViewControllerDelegate.h"
 
#import "MBMicroblinkDefines.h"
#import <Foundation/Foundation.h>
 
/**
 * Class containing all metadata delegates
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIRecognizerRunnerViewControllerMetadataDelegates : NSObject
 
@property (nonatomic, weak, nullable) id<MBIDebugRecognizerRunnerViewControllerDelegate> debugRecognizerRunnerViewControllerDelegate;
@property (nonatomic, weak, nullable) id<MBIDetectionRecognizerRunnerViewControllerDelegate> detectionRecognizerRunnerViewControllerDelegate;
@property (nonatomic, weak, nullable) id<MBIOcrRecognizerRunnerViewControllerDelegate> ocrRecognizerRunnerViewControllerDelegate;
@property (nonatomic, weak, nullable) id<MBIGlareRecognizerRunnerViewControllerDelegate> glareRecognizerRunnerViewControllerDelegate;
 
@end
 