//
//  MBBarcodeResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 28/11/2017.
//

/**
 * Enumeration of possible barcode formats
 */
typedef NS_ENUM(NSInteger, MBIBarcodeType) {
    MBIBarcodeNone = 0,
    /** QR code */
    MBIBarcodeTypeQR,
    /** Data Matrix */
    MBIBarcodeTypeDataMatrix,
    /** UPCE */
    MBIBarcodeTypeUPCE,
    /** UPCA */
    MBIBarcodeTypeUPCA,
    /** EAN 8 */
    MBIBarcodeTypeEAN8,
    /** EAN 13 */
    MBIBarcodeTypeEAN13,
    /** Code 128 */
    MBIBarcodeTypeCode128,
    /** Code 39 */
    MBIBarcodeTypeCode39,
    /** ITF */
    MBIBarcodeTypeITF,
    /** Code 39 */
    MBIBarcodeTypeAztec,
    /** PDF 417 */
    MBIBarcodeTypePdf417
};
