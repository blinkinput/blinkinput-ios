//
//  MBDocumentCaptureOverlaySettings.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 13/01/2020.
//

#import "MBBaseOverlaySettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Settings class containing parameters for Document Capture UI
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBDocumentCaptureOverlaySettings : MBBaseOverlaySettings
/**
 * Designated initializer. Initializes the object with default settings.
 *
 *  @return object initialized with default values.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
* Background color of document capture detection view
* Default: UIColor red:.282 green:.698 blue:.91
*/
@property (nonatomic, strong) UIColor *backgroundColor;

/**
* Border color of document capture detection view
* Default: UIColor red:.282 green:.698 blue:.91
*/
@property (nonatomic, strong) UIColor *borderColor;

/**
* Opacity of document capture detection view
* Default: 0.35
*/
@property (nonatomic, assign) CGFloat alphaOpacity;

@end

NS_ASSUME_NONNULL_END
