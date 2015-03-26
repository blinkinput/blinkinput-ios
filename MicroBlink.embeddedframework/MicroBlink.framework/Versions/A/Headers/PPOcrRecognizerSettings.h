//
//  PPOcrRecognizerSettings.h
//  PhotoPayFramework
//
//  Created by Jura on 03/11/14.
//  Copyright (c) 2014 MicroBlink Ltd. All rights reserved.
//

#import "PPRecognizerSettings.h"

#import "PPOcrParserFactory.h"

// Parser for raw text
#import "PPRawOcrParserFactory.h"

// Generic Parsers
#import "PPIbanOcrParserFactory.h"
#import "PPPriceOcrParserFactory.h"
#import "PPEmailOcrParserFactory.h"

// Swedish Parsers
#import "PPSwedenAmountOcrParserFactory.h"
#import "PPSwedenBankGiroNumberOcrParserFactory.h"
#import "PPSwedenReferenceOcrParserFactory.h"
#import "PPSwedenSlipCodeOcrParserFactory.h"

// Croatian Parsers
#import "PPCroReferenceOcrParserFactory.h"

@interface PPOcrRecognizerSettings : PPRecognizerSettings

- (instancetype)init;

- (void)addOcrParser:(PPOcrParserFactory *)factory name:(NSString *)name;

- (void)addOcrParser:(PPOcrParserFactory *)factory name:(NSString *)name group:(NSString *)group;

- (void)removeOcrParserWithName:(NSString *)name;

- (void)clearParsersInGroup:(NSString*)group;

- (void)clearAllParsers;

@end
