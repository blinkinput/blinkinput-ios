//
//  PPBaseResult.h
//  BarcodeFramework
//
//  Created by Jura on 04/04/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPResultDataSourceAdapter;

/**
 Enumeration of all result types
 */
typedef NS_ENUM(NSInteger, PPBaseResultType) {
    PPBaseResultTypeBarcode,
    PPBaseResultTypeUSDL,
    PPBaseResultTypePhotoPay,
    PPBaseResultTypeOCR,
    PPBaseResultTypePhotoMath,
    PPBaseResultTypeIDCard
};

struct RecognitionResultImpl;
typedef struct RecognitionResultImpl RecognitionResultImpl;

/**
 Abstract result of pdf417.mobi library
 */
@interface PPBaseResult : NSObject <NSCopying>

/**
 Type of the result

 For easier type checking when casting
 */
@property (nonatomic, assign, readonly) PPBaseResultType resultType;

/**
 * Private implementation
 */
@property (nonatomic, assign) RecognitionResultImpl *recognitionResult;

// TODO: add location on image

/**
 Designated initializer
 
 Requires the type property
 */
- (id)initWithRecognitionResult:(struct RecognitionResultImpl *)recognitionResult
                     resultType:(PPBaseResultType)resultType;

/**
 Returns the xml representation of this result
 TODO: remove this nonsense
 */
- (NSString*)xml;

/**
 Returns the attributed version of description string
 */
- (NSAttributedString*)attributedDescription;

/**
 Convenience method for simple display of result inside UITableView
 TODO: remove this nonsense
 */
- (PPResultDataSourceAdapter*)getAdapter;

@end
