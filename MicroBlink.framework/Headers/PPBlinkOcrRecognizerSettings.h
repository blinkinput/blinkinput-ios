//
//  PPOcrRecognizerSettings.h
//  PhotoPayFramework
//
//  Created by Jura on 03/11/14.
//  Copyright (c) 2014 MicroBlink Ltd. All rights reserved.
//

#import "PPTemplatingRecognizerSettings.h"

#import "PPOcrParserFactory.h"

// Parser for raw text
#import "PPRawOcrParserFactory.h"

// Regex parser
#import "PPRegexOcrParserFactory.h"

// Generic Parsers
#import "PPDateOcrParserFactory.h"
#import "PPEmailOcrParserFactory.h"
#import "PPIbanOcrParserFactory.h"
#import "PPPriceOcrParserFactory.h"

#import "PPDetectorSettings.h"
#import "PPDocumentClassifier.h"

NS_ASSUME_NONNULL_BEGIN

PP_CLASS_AVAILABLE_IOS(6.0) @interface PPBlinkOcrRecognizerSettings : PPTemplatingRecognizerSettings

- (instancetype)init;

@property (nonatomic) PPDetectorSettings *detectorSettings;

@property (nonatomic) BOOL allowFlippedRecognition;

@property (nonatomic) id<PPDocumentClassifier> documentClassifier;

@end

NS_ASSUME_NONNULL_END