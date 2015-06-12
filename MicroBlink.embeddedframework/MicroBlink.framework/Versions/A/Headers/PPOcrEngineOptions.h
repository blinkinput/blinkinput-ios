//
//  PPOcrEngineOptions.h
//  BlinkOcrFramework
//
//  Created by Jura on 30/04/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A list of fonts supported by BlinkOCR
 */
typedef NS_ENUM(NSUInteger, PPOcrFont) {

    PP_OCR_FONT_AKZIDENZ_GROTESK,
    PP_OCR_FONT_ARIAL,
    PP_OCR_FONT_ARIAL_BLACK,
    PP_OCR_FONT_ARNHEM,
    PP_OCR_FONT_ARQUITECTA_HEAVY,
    PP_OCR_FONT_AVANT_GARDE,
    PP_OCR_FONT_BEMBO,
    PP_OCR_FONT_BODONI,
    PP_OCR_FONT_CALIBRI,
    PP_OCR_FONT_CALIBRI_BOLD,
    PP_OCR_FONT_COMIC_SANS,
    PP_OCR_FONT_CONCERTO_ROUNDED_SG,
    PP_OCR_FONT_COURIER,
    PP_OCR_FONT_COURIER_BOLD,
    PP_OCR_FONT_COURIER_NEW_CE,
    PP_OCR_FONT_COURIER_CONDENSED,
    PP_OCR_FONT_DEJAVU_SANS_MONO,
    PP_OCR_FONT_DIN,
    PP_OCR_FONT_EUROPA_GROTESK_NO_2_SB_BOLD,
    PP_OCR_FONT_EUROSTILE,
    PP_OCR_FONT_F25_BANK_PRINTER_BOLD,
    PP_OCR_FONT_FRANKLIN_GOTHIC,
    PP_OCR_FONT_FRUTIGER,
    PP_OCR_FONT_FUTURA,
    PP_OCR_FONT_FUTURA_BOLD,
    PP_OCR_FONT_GARAMOND,
    PP_OCR_FONT_GEORGIA,
    PP_OCR_FONT_GILL_SANS,
    PP_OCR_FONT_HELVETICA,
    PP_OCR_FONT_HELVETICA_BOLD,
    PP_OCR_FONT_INTERSTATE,
    PP_OCR_FONT_LATIN_MODERN,
    PP_OCR_FONT_LATIN_MODERN_ITALIC,
    PP_OCR_FONT_LETTER_GOTHIC,
    PP_OCR_FONT_LUCIDA,
    PP_OCR_FONT_LUCIDA_SANS,
    PP_OCR_FONT_MATRIX,
    PP_OCR_FONT_META,
    PP_OCR_FONT_MINION,
    PP_OCR_FONT_OCRA,
    PP_OCR_FONT_OCRB,
    PP_OCR_FONT_OFFICINA,
    PP_OCR_FONT_OPTIMA,
    PP_OCR_FONT_ROCKWELL,
    PP_OCR_FONT_ROTIS_SANS_SERIF,
    PP_OCR_FONT_ROTIS_SERIF,
    PP_OCR_FONT_SABON,
    PP_OCR_FONT_STONE,
    PP_OCR_FONT_SV_BASIC_MANUAL,
    PP_OCR_FONT_TAHOMA,
    PP_OCR_FONT_TEX_GYRE_TERMES,
    PP_OCR_FONT_TEX_GYRE_TERMES_ITALIC,
    PP_OCR_FONT_THE_SANS_MONO_CONDENSED_BLACK,
    PP_OCR_FONT_THESIS,
    PP_OCR_FONT_TIMES_NEW_ROMAN,
    PP_OCR_FONT_TRAJAN,
    PP_OCR_FONT_TRINITE,
    PP_OCR_FONT_UNIVERS,
    PP_OCR_FONT_VERDANA,
    PP_OCR_FONT_VOLTAIRE,
    PP_OCR_FONT_WALBAUM,
    PP_OCR_FONT_EUROPA_GRO_SB,
    PP_OCR_FONT_EUROPA_GRO_SB_LIGHT,

    // from now on "special" fonts
    PP_OCR_FONT_MICR,
    PP_OCR_FONT_HANDWRITING,
    PP_OCR_FONT_UNKNOWN,
    PP_OCR_FONT_ANY,
    PP_OCR_FONT_UNKNOWN_MATH,
    PP_OCR_FONT_UKDL_LIGHT,
};


/**
 * Class representing a char in specific font.
 *
 * @example char 'k' in font Arial
 *  PPOcrCharKey* key = [[PPOcrCharKey alloc] initWithCode:'k' font:PP_OCR_FONT_ARIAL];
 *
 * @example char 'ü' in any font
 *  PPOcrCharKey* key = [[PPOcrCharKey alloc] initWithCode:'ü' font:PP_OCR_FONT_ANY];
 *
 */
@interface PPOcrCharKey : NSObject

/**
 * Unicode value of the char. For example, for char 'k', you can use either 'k' or 107.
 */
@property (nonatomic, assign) int code;

/**
 * Font of the char. Can be specific (for example PP_OCR_FONT_ARIAL), or any font (PP_OCR_FONT_ANY), which is the same
 * as specifying the same char code with all supported fonts.
 */
@property (nonatomic, assign) PPOcrFont font;

/**
 * Initializer which specifies the code and font of the char.
 *
 *  @param code Unicode value for the char
 *  @param font Font of the char
 *
 *  @return initialized char key
 */
- (instancetype)initWithCode:(int)code
                        font:(PPOcrFont)font;

/**
 * Factory method for easier instantiation
 *
 *  @param code Unicode value for the char
 *  @param font Font of the char
 *
 *  @return initialized char key
 */
+ (instancetype)keyWithCode:(int)code
                       font:(PPOcrFont)font;

@end

typedef struct OcrEngineOptionsImpl OcrEngineOptionsImpl;

/**
 * Options used for OCR process
 */
@interface PPOcrEngineOptions : NSObject <NSCopying>

/**
 * Internal implementation
 */
@property (nonatomic, readonly, assign) OcrEngineOptionsImpl* options;

/**
 * Minimal height of the line of text given in pixels. All chars smaller than this value will be ignored.
 *
 * Setting the minimal line height can reduce the noise in OCR results.
 */
@property (nonatomic, assign) NSUInteger minimalLineHeight;

/**
 * Maximal height of the line of text given in pixels.
 *
 * Setting the maximal line height can reduce the noise in OCR results.
 */
@property (nonatomic, assign) NSUInteger maximalLineHeight;

/**
 * Maximal chars expected on the image.
 * 
 * Setting this value can speed up the OCR processing because all images with more chars than specified will be ignored 
 * (becuase in most cases they are noise)
 */
@property (nonatomic, assign) NSUInteger maxCharsExpected;

/**
 * Specifies if the additional image processing which drops the background colors should be performed.
 * 
 * Use this if you have black text on color backgrounds.
 * If you have black text on white background, using this is not needed as it slows down processing.
 * If you have color text, don't use it at all because color dropout will remove the text.
 */
@property (nonatomic, assign) BOOL colorDropoutEnabled;

/**
 * Specifies if the image processing is performed on image 
 *
 * By default it's set to true.
 * Disable it only if you perform your own image processing.
 */
@property (nonatomic, assign) BOOL imageProcessingEnabled;

/**
 * Whitelist of characters used in the OCR process. The set must contain PPOcrCharKey objects.
 */
@property (nonatomic, strong) NSSet* charWhitelist;


@end
