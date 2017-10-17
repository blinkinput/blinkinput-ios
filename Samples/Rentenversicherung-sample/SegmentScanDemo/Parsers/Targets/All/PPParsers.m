//
//  PPParsers.m
//  SegmentScanDemo
//
//  Created by Dino on 31/03/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "PPParsers.h"
#import "PPScanElement.h"
#import <MicroBlink/MicroBlink.h>

@interface PPParsers ()

@end

@implementation PPParsers

+ (NSArray *)getAvailableParsers {
    NSMutableArray *retArray = [NSMutableArray array];
    PPRawOcrParserFactory *rawFactory = [[PPRawOcrParserFactory alloc] init];
    rawFactory.isRequired = NO;
    PPScanElement *rawElement = [[PPScanElement alloc] initWithIdentifier:kVersicherungsnummer parserFactory:rawFactory];
    rawElement.localizedTitle = @"Versicherungsnummer";
    rawElement.localizedTooltip = @"Bitte positionieren Sie die Versicherungsnummer in diesem Feld";
    rawElement.scanningRegionHeight = 0.14;
    rawElement.scanningRegionWidth = 0.8;
    [retArray addObject:rawElement];
    
    PPDateOcrParserFactory *dateFactory = [[PPDateOcrParserFactory alloc] init];
    dateFactory.isRequired = NO;
    PPScanElement *dateElement = [[PPScanElement alloc] initWithIdentifier:kDatum parserFactory:dateFactory];
    dateElement.localizedTitle = @"Datum";
    dateElement.localizedTooltip = @"Bitte positionieren Sie Datum in diesem Feld";
    dateElement.scanningRegionHeight = 0.10;
    dateElement.scanningRegionWidth = 0.7;
    [retArray addObject:dateElement];
    
    
    PPRawOcrParserFactory *priceFactory = [[PPRawOcrParserFactory  alloc] init];
    priceFactory.isRequired = NO;
    PPScanElement *priceElement = [[PPScanElement alloc] initWithIdentifier:kRente parserFactory:priceFactory];
    priceElement.localizedTitle = @"Renten";
    priceElement.localizedTooltip = @"Bitte positionieren Sie die monatliche Renten in diesem Feld";
    priceElement.scanningRegionHeight = 0.30;
    priceElement.scanningRegionWidth = 0.5;
    [retArray addObject:priceElement];
    
    
    return retArray;
    
}

+ (NSArray *)getInitialParsers {
    NSMutableArray *retArray = [NSMutableArray array];
    PPRawOcrParserFactory *rawFactory = [[PPRawOcrParserFactory alloc] init];
    rawFactory.isRequired = NO;
    PPScanElement *rawElement = [[PPScanElement alloc] initWithIdentifier:kVersicherungsnummer parserFactory:rawFactory];
    rawElement.localizedTitle = @"Versicherungsnummer";
    rawElement.localizedTooltip = @"Bitte positionieren Sie die Versicherungsnummer in diesem Feld";
    rawElement.scanningRegionHeight = 0.14;
    rawElement.scanningRegionWidth = 0.8;
    [retArray addObject:rawElement];
    
    PPDateOcrParserFactory *dateFactory = [[PPDateOcrParserFactory alloc] init];
    dateFactory.isRequired = NO;
    PPScanElement *dateElement = [[PPScanElement alloc] initWithIdentifier:kDatum parserFactory:dateFactory];
    dateElement.localizedTitle = @"Datum";
    dateElement.localizedTooltip = @"Bitte positionieren Sie Datum in diesem Feld";
    dateElement.scanningRegionHeight = 0.10;
    dateElement.scanningRegionWidth = 0.7;
    [retArray addObject:dateElement];
    
    
    PPRawOcrParserFactory *priceFactory = [[PPRawOcrParserFactory  alloc] init];
    priceFactory.isRequired = NO;
    PPScanElement *priceElement = [[PPScanElement alloc] initWithIdentifier:kRente parserFactory:priceFactory];
    priceElement.localizedTitle = @"Renten";
    priceElement.localizedTooltip = @"Bitte positionieren Sie die monatliche Renten in diesem Feld";
    priceElement.scanningRegionHeight = 0.30;
    priceElement.scanningRegionWidth = 0.5;
    [retArray addObject:priceElement];
    
    
    return retArray;
}

+ (BOOL)areSettingsAllowed {
    return NO;
}

@end
