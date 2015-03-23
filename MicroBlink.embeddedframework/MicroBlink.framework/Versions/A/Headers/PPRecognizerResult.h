//
//  PPRecognizerResult.h
//  MicroBlinkFramework
//
//  Created by Jura on 04/04/14.
//  Copyright (c) 2015 MicroBlink ČLtd.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPResultDataSourceAdapter;

struct RecognitionResultImpl;
typedef struct RecognitionResultImpl RecognitionResultImpl;

/**
 Abstract result of pdf417.mobi library
 */
@interface PPRecognizerResult : NSObject <NSCopying>

/**
 * Private implementation
 */
@property (nonatomic, assign) RecognitionResultImpl *recognitionResult;

/**
 Designated initializer
 
 Requires the type property
 */
- (instancetype)initWithRecognitionResult:(struct RecognitionResultImpl *)recognitionResult;

/**
 Returns the xml representation of this result
 */
- (NSString*)xml;

/**
 Returns the attributed version of description string
 */
- (NSAttributedString*)attributedDescription;

/**
 Convenience method for simple display of result inside UITableView
 */
- (PPResultDataSourceAdapter*)getAdapter;

@end
