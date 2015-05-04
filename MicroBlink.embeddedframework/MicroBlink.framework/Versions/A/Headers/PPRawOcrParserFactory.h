//
//  PPRawOcrParserFactory.h
//  PhotoPayFramework
//
//  Created by Jura on 27/02/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import "PPOcrParserFactory.h"

#import "PPOcrEngineOptions.h"

/**
 * Parser responsible for parsing raw OCR text
 */
@interface PPRawOcrParserFactory : PPOcrParserFactory

/**
 * Ocr Engine options used in Raw ocr parsing
 */
@property (nonatomic, strong) PPOcrEngineOptions *options;

/**
 * Use algorithm for combining consecutive OCR results between video frames
 */
@property (nonatomic, assign) BOOL useSieve;

@end
