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

@class MBINProcessor;

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer for BlinkInput API and general OCR recognition
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBINBlinkInputRecognizer : MBINRecognizer<NSCopying>

- (instancetype)initWithProcessors:(NSArray<MBINProcessor *> *)processors NS_DESIGNATED_INITIALIZER;


/**
 * Getting array of readonly processors
 */
@property (nonatomic, strong, readonly) NSArray<MBINProcessor *> *processors;

/**
 * BlinkInput recognizer results
 */
@property (nonatomic, strong, readonly) MBINBlinkInputRecognizerResult *result;

@end

NS_ASSUME_NONNULL_END
