//
//  PPImage.h
//  BlinkIdFramework
//
//  Created by Dino on 25/02/16.
//  Copyright © 2016 Microblink Ltd. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "CoreMedia/CoreMedia.h"
#import <UIKit/UIKit.h>
#import "MBMicroblinkDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Enum which describes text orientation on an image.
 */
typedef NS_ENUM(NSInteger, MBINProcessingOrientation) {
    /** Text oriented same as picture */
    MBINProcessingOrientationUp,
    /** Text is rotated 90 degrees clockwise */
    MBINProcessingOrientationRight,
    /** Text is upside down */
    MBINProcessingOrientationDown,
    /** Text is rotated 90 degrees counterclockwise */
    MBINProcessingOrientationLeft,
};

/**
 * Object which represents an image.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBINImage : NSObject

/**
 * UIImage of wrapped image.
 * If this MBINImage wasn't created with UIImage, UIImage will be created with first access of this property.
 */
@property (nonatomic, readonly, nullable) UIImage *image;

/**
 * Region of the image used for scanning, where the whole image is specified with CGRectMake(0.0, 0.0, 1.0, 1.0).
 */
@property (nonatomic) CGRect roi;

/**
 * Processing orientation of image. This is used in OCR where you can specify character orientation.
 *
 * Default: MBINProcessingOrientationUp
 */
@property (nonatomic) MBINProcessingOrientation orientation;

/**
 * Tells whether camera input images should be mirrored horizontally before processing
 *
 * Default: NO
 */
@property (nonatomic) BOOL mirroredHorizontally;

/**
 * Tells whether camera input images should be mirrored vertically before processing
 *
 * Default: NO
 */
@property (nonatomic) BOOL mirroredVertically;


/**
 * If YES, the image will prior to processing go through frame quality estimation phase, which might discard the frame
 *
 * Default: NO.
 */
@property (nonatomic) BOOL estimateFrameQuality;

/**
 *  Property which tells if this frame is a camera or a single photo frame.
 *  This is important for image processing.
 *
 *  Default: YES if created with CMSampleBuffer, NO if created with UIImage
 */
@property (nonatomic) BOOL cameraFrame;

/**
 * Creates MBINImage around UIImage.
 */
+ (instancetype)imageWithUIImage:(UIImage *)image;

/**
 * Creates MBINImage around CVImageBufferRef.
 */
+ (instancetype)imageWithCmSampleBuffer:(CMSampleBufferRef)buffer;

/**
 * Creates MBINImage around CVPixelBufferRef.
 */
+ (instancetype)imageWithCvPixelBuffer:(CVPixelBufferRef)buffer;

@end

NS_ASSUME_NONNULL_END
