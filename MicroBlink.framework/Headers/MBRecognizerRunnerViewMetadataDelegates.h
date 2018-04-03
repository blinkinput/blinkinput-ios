#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"

@protocol MBDetectionRecognizerRunnerViewDelegate;
@protocol MBDebugRecognizerRunnerViewDelegate;
@protocol MBOcrRecognizerRunnerViewDelegate;

@class MBOverlayViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * Class containing all metadata delegates
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBRecognizerRunnerViewMetadataDelegates : NSObject

@property (nonatomic, weak) MBOverlayViewController<MBDetectionRecognizerRunnerViewDelegate> *detectionRecognizerRunnerViewDelegate;
@property (nonatomic, weak) MBOverlayViewController<MBDebugRecognizerRunnerViewDelegate> *debugRecognizerRunnerViewDelegate;
@property (nonatomic, weak) MBOverlayViewController<MBOcrRecognizerRunnerViewDelegate> *ocrRecognizerRunnerViewDelegate;

@end

NS_ASSUME_NONNULL_END