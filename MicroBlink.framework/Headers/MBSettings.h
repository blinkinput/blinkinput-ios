//
//  MBSettings.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 24/11/2017.
//

#ifndef PhotoPayFramework_SettingsKeys_h
#define PhotoPayFramework_SettingsKeys_h

#import "MBCameraSettings.h"
#import "MBUiSettings.h"
#import "MBMetadataSettings.h"

#import "PPMicroBlinkDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Settings class with all possible customizable settings in the scanning process
 *
 * Contains:
 *  - Camera Settings: for customizing camera controls
 *  - License Settings:
 */
PP_CLASS_AVAILABLE_IOS(6.0)

@interface MBSettings : NSObject<NSCopying>

/**
 * Initializes the PPSettings with all default values.
 *
 * @see individual properties for defaults.
 *
 * @return Initialized PPSettings object
 */
- (instancetype)init;

/**
 * Initializes the PPSettings with a given resource bundle.
 *
 * @see individual properties for defaults. Resource bundle will be set to the bundle passed as parametere here.
 *
 * @return Initialized PPSettings object
 */
- (instancetype)initWithResourceBundle:(NSBundle *)bundle NS_DESIGNATED_INITIALIZER;

/**
 * Settings related to Camera control
 */
@property (nonatomic) MBCameraSettings *cameraSettings;

/**
 * Settings for camera UI
 */
@property (nonatomic) MBUiSettings *uiSettings;

/**
 * Settings for obtaining metadata in the scanning process.
 */
@property (nonatomic) MBMetadataSettings *metadataSettings;

/**
 * Bundle in which the resources for the scanning process should be found. Usually, by default, this
 * is equal to Microblink.bundle located in Main app bundle.
 *
 * i.e, this is by default initialized to:
 *   [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MicroBlink" ofType:@"bundle"];
 *
 * This is a readonly property. If you want to set it, please use initWithResourceBundle: initialized
 */
@property (nonatomic, readonly) NSBundle *resourcesBundle;

@end

NS_ASSUME_NONNULL_END

#endif
