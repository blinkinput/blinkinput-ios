//
//  MBPdf417RecognizerResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 27/11/2017.
//

#import <Foundation/Foundation.h>

#import "MBMicroBlinkDefines.h"
#import "MBRecognizerResult.h"
#import "MBBarcodeResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that can scan PDF417 2D barcodes.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBPdf417RecognizerResult : MBRecognizerResult<NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Byte array with result of the scan
 */
- (NSData *_Nullable)data;

/**
 * Retrieves string content of scanned data
 */
- (NSString *)stringData;

/**
 * Flag indicating uncertain scanning data
 * E.g obtained from damaged barcode.
 */
- (BOOL)isUncertain;

/**
 * Type of the barcode scanned
 *
 *  @return Type of the barcode
 */
@property(nonatomic, assign, readonly) MBBarcodeType barcodeType;

@end

NS_ASSUME_NONNULL_END

