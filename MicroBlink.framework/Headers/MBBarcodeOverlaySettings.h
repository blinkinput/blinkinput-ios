//
//  MBBarcodeOverlaySettings.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 16/01/2018.
//

#import "MBSettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Settings class containing parameters for Barcode UI
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBBarcodeOverlaySettings : MBSettings

/**
 * If YES, viewfinder (4 corner markers) will move when payslip is detected
 *
 * Default: YES
 */
@property (nonatomic, assign) BOOL viewfinderMoveable;

/**
 * If YES; barcode dots will be displayed if detected.
 *
 * Default: YES
 */
@property (nonatomic, assign) BOOL displayBarcodeDots;

@end

NS_ASSUME_NONNULL_END
