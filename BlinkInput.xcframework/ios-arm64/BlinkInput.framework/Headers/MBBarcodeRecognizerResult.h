//
//  MBBarcodeRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 28/11/2017.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBRecognizerResult.h"
#import "MBBarcodeType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Result of MBIBarcodeRecognizer; is used for scanning most of 1D barcode formats, and 2D format
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBIBarcodeRecognizerResult : MBIRecognizerResult<NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Byte array with result of the scan
 */
@property(nonatomic, strong, readonly, nullable) NSData* rawData;

/**
 * Retrieves string content of scanned data
 */
@property(nonatomic, strong, readonly, nullable) NSString* stringData;

/**
 * Flag indicating uncertain scanning data
 * E.g obtained from damaged barcode.
 */
@property(nonatomic, assign, readonly) BOOL uncertain;

/**
 * Method which gives string representation for a given MBIBarcodeType enum value.
 *
 *  @param type MBIBarcodeType enum value
 *
 *  @return String representation of a given MBIBarcodeType enum value.
 */
+ (NSString *_Nonnull)toTypeName:(MBIBarcodeType)type;

/**
 * Type of the barcode scanned
 *
 *  @return Type of the barcode
 */
@property(nonatomic, assign, readonly) MBIBarcodeType barcodeType;


@end

NS_ASSUME_NONNULL_END