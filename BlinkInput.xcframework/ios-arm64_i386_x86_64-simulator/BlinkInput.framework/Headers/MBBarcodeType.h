//
//  MBBarcodeResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 28/11/2017.
//

/**
 * Enumeration of possible barcode formats
 */
typedef NS_ENUM(NSInteger, MBINBarcodeType) {
    MBINBarcodeNone = 0,
    /** QR code */
    MBINBarcodeTypeQR,
    /** Data Matrix */
    MBINBarcodeTypeDataMatrix,
    /** UPCE */
    MBINBarcodeTypeUPCE,
    /** UPCA */
    MBINBarcodeTypeUPCA,
    /** EAN 8 */
    MBINBarcodeTypeEAN8,
    /** EAN 13 */
    MBINBarcodeTypeEAN13,
    /** Code 128 */
    MBINBarcodeTypeCode128,
    /** Code 39 */
    MBINBarcodeTypeCode39,
    /** ITF */
    MBINBarcodeTypeITF,
    /** Code 39 */
    MBINBarcodeTypeAztec,
    /** PDF 417 */
    MBINBarcodeTypePdf417
};
