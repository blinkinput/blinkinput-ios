//
//  PPDocument.h
//  BlinkIdFramework
//
//  Created by Jura on 07/01/16.
//  Copyright © 2016 Microblink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MBMicroblinkDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Struct which defines a range on the image
 */
typedef struct MBIRange {
    CGFloat start;
    CGFloat stop;
} MBIRange;

/**
 * Method which creates a range structure
 */
NS_INLINE MBIRange MBIMakeRange(CGFloat start, CGFloat stop) {
    MBIRange r;
    r.start = start;
    r.stop = stop;
    return r;
}

/**
 * Struct which defines a scale which detector searches on the image
 */
typedef struct MBIScale {
    CGFloat scale;
    CGFloat tolerance;
} MBIScale;

/**
 * Method which creates a scale structure
 */
NS_INLINE MBIScale MBIMakeScale(CGFloat scale, CGFloat tolerance) {
    MBIScale r;
    r.scale = scale;
    r.tolerance = tolerance;
    return r;
}

/**
 * Enum of different scanning modes: Landscape, Portrait and Auto(both)
 */
typedef NS_ENUM(NSInteger, MBIScanningMode) {

    /** Detects document in both directions */
    MBIScanningModeAuto,

    /** Detects document in landscape direction */
    MBIScanningModeLandscape,

    /** Detects document in portrait direction */
    MBIScanningModePortrait,
};

/** Presets which can be used to instantiate document specification for a specific document format */
typedef NS_ENUM(NSInteger, MBIDocumentSpecificationPreset) {

    /** Preset for detecting ID1 cards */
    MBIDocumentSpecificationId1Card,

    /** Preset for detecting ID2 cards */
    MBIDocumentSpecificationId2Card,

    /** Preset for detecting cheques */
    MBIDocumentSpecificationCheque,

    /** Preset for detecting A4 documents in portrait */
    MBIDocumentSpecificationA4Portrait,

    /** Preset for detecting A4 documents in landscape */
    MBIDocumentSpecificationA4Landscape,
    
    /** Preset for detecting vertical ID1 cards */
    MBIDocumentSpecificationId1VerticalCard,
    
    /** Preset for detecting vertical ID1 cards */
    MBIDocumentSpecificationId2VerticalCard,
};

/**
 * Document class describes a document which is being detected by DocumentDetector.
 * We encurage users to create specifications with one of our presets, if possible.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBIDocumentSpecification : NSObject <NSCopying>

/**
 * Use this initializer for specifiying a document format.
 *
 *  @param aspectRatio  Aspect ratio of the document. Calculated as width / height
 *
 *  @return initialized object
 */
- (instancetype)initWithAspectRatio:(CGFloat)aspectRatio physicalSizeInInches:(CGFloat)physicalSizeInInches;


// unavailable initializer
- (instancetype)init NS_UNAVAILABLE;

/**
 * Factory method which creates Document specification based on a preset
 *
 *  @param preset document preset
 *
 *  @return new instance for a given document preset
 */
+ (instancetype)createFromPreset:(MBIDocumentSpecificationPreset)preset;

/**
 * Sets scale and scale tolerance that will be used when detecting document in both orientations.
 */
- (void)setPortraitAndLandscapeScale:(MBIScale)scale;

/**
 * Maximum angle for document detection
 *
 * Default 25.0
 */
@property (nonatomic, assign) CGFloat maxAngle;

/**
 * Scale and scale tolerance that will be used when detecting document in portrait orientation.
 *
 * Default: MBIMakeScale(1.0, 0.0)
 */
@property (nonatomic, assign) MBIScale portraitScale;

/**
 * Scale and scale tolerance that will be used when detecting document in landscape orientation.
 *
 * Default: MBIMakeScale(1.0, 0.0)
 */
@property (nonatomic, assign) MBIScale landscapeScale;

/**
 * Scanning mode that defines in which orientations can this document be detected.
 *
 * Default: MBIScanningModeAuto
 */
@property (nonatomic, assign) MBIScanningMode scanningMode;

/**
 * Percentage of possible document offset on x axis.
 *
 * Default: MBIMakeRange(-1, -1);
 */
@property (nonatomic, assign) MBIRange xRange;

/**
 * Percentage of possible document offset on y axis.
 *
 * Default: MBIMakeRange(-1, -1);
 */
@property (nonatomic, assign) MBIRange yRange;

/**
 * Physical size of document in inches
 */
@property (nonatomic, assign, readonly) CGFloat physicalSizeInInches;

@end

NS_ASSUME_NONNULL_END
