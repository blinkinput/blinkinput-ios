//
//  MBSimNumberRecognizer.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 21/11/2017.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"
#import "MBRecognizer.h"
#import "MBSimNumberRecognizerResult.h"
#import "MBMicroBlinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Recognizer that can perform recognition of barcodes on SIM packaging.
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBSimNumberRecognizer : MBRecognizer<NSCopying>

MB_INIT

/**
 * Sim number recognizer results
 */
@property (nonatomic, strong, readonly) MBSimNumberRecognizerResult *result;

@end

NS_ASSUME_NONNULL_END
