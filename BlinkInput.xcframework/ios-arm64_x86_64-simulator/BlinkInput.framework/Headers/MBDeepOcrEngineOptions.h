//
//  MBDeepOcrEngineOptions.h
//  BlinkInputDev
//
//  Created by Jura Skrlec on 09/08/2017.
//
//

#import <CoreGraphics/CGBase.h>

#import "MBMicroblinkDefines.h"
#import "MBBaseOcrEngineOptions.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Type of the document which recognizer scans
 */
typedef NS_ENUM(NSInteger, MBIDeepOcrModel) {

    /** Deep OCR model for Blink Input */
    MBIDeepOcrModelBlinkInput
};

/**
 * Options used for OCR process. These options enable you to customize how some OCR parsers work.
 * For example, you can set nms threshold, score threshold, the ID of the requested Deep OCR model etc.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBIDeepOcrEngineOptions : MBIBaseOcrEngineOptions <NSCopying>

/**
 * Returns or sets nms threshold for deep ocr postprocessing
 *
 * Default: 0.3f
 */
@property (nonatomic, assign) CGFloat deepOcrPostprocessorNmsThreshold;

/**
 * Returns or sets score threshold for deep ocr postprocessing
 *
 * Default: 0.15f
 */
@property (nonatomic, assign) CGFloat deepOcrPostprocessorScoreThreshold;

/**
 * Returns or sets model for deep ocr postprocessing
 *
 * Default: MBIBlinkOCR
 */
@property (nonatomic, assign) MBIDeepOcrModel deepOcrModel;

/**
 * Returns or sets model for deep ocr postprocessing
 *
 * Default: MBIBlinkOCR
 */
@property (nonatomic, assign) NSString *deepOcrModelString;

@end

NS_ASSUME_NONNULL_END
