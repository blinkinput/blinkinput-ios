//
//  MBBlinkInputRecognizer.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 02/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBRecognizer.h"
#import "MBBlinkInputRecognizerResult.h"
#import "MBMicroblinkInitialization.h"

@class MBIProcessor;

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer for BlinkInput API and general OCR recognition
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIBlinkInputRecognizer : MBIRecognizer<NSCopying>

- (instancetype)initWithProcessors:(NSArray<MBIProcessor *> *)processors NS_DESIGNATED_INITIALIZER;


/**
 * Getting array of readonly processors
 */
@property (nonatomic, strong, readonly) NSArray<MBIProcessor *> *processors;

/**
 * BlinkInput recognizer results
 */
@property (nonatomic, strong, readonly) MBIBlinkInputRecognizerResult *result;

@end

NS_ASSUME_NONNULL_END
