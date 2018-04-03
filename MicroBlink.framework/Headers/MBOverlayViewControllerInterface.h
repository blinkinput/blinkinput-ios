//
//  MBOverlayViewControllerInterface.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 15/01/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBSettings;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for Overlay View controllers which returns required MBSettings
 */
@protocol MBOverlayViewControllerInterface <NSObject>

@required
- (MBSettings *)getSettings;

@end

NS_ASSUME_NONNULL_END
