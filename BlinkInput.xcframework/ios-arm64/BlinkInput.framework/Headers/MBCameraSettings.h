//
//  PPCameraSettings.h
//  PhotoPayFramework
//
//  Created by Jura on 23/02/15.
//  Copyright (c) 2015 Microblink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "MBMicroblinkDefines.h"

/**
 * Camera resolution preset
 */
typedef NS_ENUM(NSInteger, MBICameraPreset) {

    /** 480p video will always be used */
    MBICameraPreset480p,

    /** 720p video will always be used */
    MBICameraPreset720p,
    
    /** 1080p video will always be used */
    MBICameraPreset1080p,
    
    /** 4K video will always be used */
    MBICameraPreset4K,

    /** The library will calculate optimal resolution based on the use case and device used */
    MBICameraPresetOptimal,

    /** Device's maximal video resolution will be used. */
    MBICameraPresetMax,

    /** Device's photo preview resolution will be used */
    MBICameraPresetPhoto,
};

/**
 * Camera type
 */
typedef NS_ENUM(NSInteger, MBICameraType) {

    /** Back facing camera */
    MBICameraTypeBack,

    /** Front facing camera */
    MBICameraTypeFront
};

/**
 * Camera autofocus restricion mode
 */
typedef NS_ENUM(NSInteger, MBICameraAutofocusRestriction) {

    /** Default. Indicates that the autofocus system should not restrict the focus range. */
    MBICameraAutofocusRestrictionNone,

    /** Indicates that the autofocus system should restrict the focus range for subject matter that is near to the camera. */
    MBICameraAutofocusRestrictionNear,

    /** Indicates that the autofocus system should restrict the focus range for subject matter that is far from the camera. */
    MBICameraAutofocusRestrictionFar,
};

/**
 * Settings class containing parameters for camera capture
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBICameraSettings : NSObject <NSCopying>

/**
 * Camera preset. With this property you can set the resolution of the camera
 *
 * Default: MBICameraPresetOptimal
 */
@property (nonatomic, assign) MBICameraPreset cameraPreset;

/**
 * Camera type. You can choose between front and back facing.
 *
 * Default: MBICameraTypeBack
 */
@property (nonatomic, assign) MBICameraType cameraType;

/**
 * Interval between forcing two camera focuses. If <= 0, forced focuses arent performed
 * and only continuous autofocus mode will be used.
 *
 * Default
 *  - 10.0f for BlinkID and BlinkOCR product
 *  - 8.0f for PhotoPay, pdf417 and other products
 */
@property (nonatomic, assign) NSTimeInterval autofocusInterval;

/**
 * Range restriction for camera autofocus.
 *
 * Default: MBICameraAutofocusRestrictionNone
 */
@property (nonatomic, assign) MBICameraAutofocusRestriction cameraAutofocusRestriction;

/**
 * Gravity of Camera preview on screen.
 *
 * Default: AVLayerVideoGravityResizeAspectFill
 */
@property (nonatomic, weak) NSString *videoGravity;

/**
 * Point against which the autofocus will be performed
 *
 * Default (0.5f, 0.5f) - middle of the screen.
 */
@property (nonatomic, assign) CGPoint focusPoint;

/**
 * Tells whether camera input images should be mirrored horizontally before processing
 *
 * Default: NO
 */
@property (nonatomic) BOOL cameraMirroredHorizontally;

/**
 * Tells whether camera input images should be mirrored vertically before processing
 *
 * Default: NO
 */
@property (nonatomic) BOOL cameraMirroredVertically;

/**
 * Set the back side preview camera layer zoom factor. 1.0 means there is no zoom, 2.0 double the zoom - preview layer is 2x zoomed than video output.
 * Valid ranges are [1.0, 2.0] - rounded to nearest two decimals. Setting previewZoomScale out of valid ranges throws an exception.
 *
 * Default: 1.0
 */
@property (nonatomic) CGFloat previewZoomScale;

/**
 * Designated initializer. Initializes the object with default settings (see above for defaults)
 *
 *  @return object initialized with default values.
 */
- (instancetype)init;

/**
 * Returns an optimal AVFoundation session preset based on cameraPreset value.
 *
 * @return optimal AVFoundation session preset
 */
- (NSString *)calcSessionPreset;

/**
 * Returns an optimal AVFoundation autofocus range restriction value based on cameraAutofocusRestriction.
 *
 * @return optimal AVFoundation autofocus range restriction
 */
- (AVCaptureAutoFocusRangeRestriction)calcAutofocusRangeRestriction;

@end
