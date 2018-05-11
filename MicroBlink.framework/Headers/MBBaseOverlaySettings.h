//
//  MBBaseOverlaySettings.h
//  MicroBlink
//
//  Created by Dino Gustin on 04/05/2018.
//

#import "MBOverlaySettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Settings class containing UI information
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBBaseOverlaySettings : MBOverlaySettings

/**
 * Scanning region
 * Defines a portion of the screen in which the scanning will be performed.
 * Given as a CGRect with unit coordinating system:
 *
 * @example CGRectMake(0.2f, 0.5f, 0.4f, 0.3f) defines a portion of the screen which starts at
 *   20% from the left border
 *   50% from the top
 *   covers 40% of screen width
 *   and 30% of screen heeight
 */
@property (nonatomic) CGRect scanningRegion;

/**
 * Full path to the sound file which is played when the valid result is scanned.
 *
 * Default: `[bundle pathForResource:@"PPbeep" ofType:@"wav"];
 */
@property (nonatomic, strong, nullable) NSString *soundFilePath;

@end

NS_ASSUME_NONNULL_END
