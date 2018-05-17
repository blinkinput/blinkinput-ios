//
//  MBDocumentOverlaySettings.h
//  MicroBlink
//
//  Created by Dino Gustin on 04/05/2018.
//

#import "MBBaseOcrOverlaySettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Settings class containing UI information
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBDocumentOverlaySettings : MBBaseOcrOverlaySettings

@property (nonatomic) BOOL viewfinderMoveable;

@end

NS_ASSUME_NONNULL_END
