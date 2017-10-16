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
    PPScanElement *rawElement = [[PPScanElement alloc] initWithIdentifier:@"Raw" parserFactory:rawFactory];
    rawElement.localizedTitle = @"Text";
    rawElement.localizedTooltip = @"Please position desired text in this field";
    rawElement.scanningRegionHeight = 0.09;
    rawElement.scanningRegionWidth = 0.8;
    [retArray addObject:rawElement];
    
    PPPriceOcrParserFactory *priceFactory = [[PPPriceOcrParserFactory alloc] init];
    priceFactory.isRequired = NO;
    PPScanElement *priceElement = [[PPScanElement alloc] initWithIdentifier:@"Price" parserFactory:priceFactory];
    priceElement.localizedTitle = @"Amount";
    priceElement.localizedTooltip = @"Please position amount in this field";
    priceElement.scanningRegionHeight = 0.09;
    priceElement.scanningRegionWidth = 0.8;
    [retArray addObject:priceElement];
    
    PPIbanOcrParserFactory *ibanFactory = [[PPIbanOcrParserFactory alloc] init];
    ibanFactory.isRequired = NO;
    PPScanElement *ibanElement = [[PPScanElement alloc] initWithIdentifier:@"IBAN" parserFactory:ibanFactory];
    ibanElement.localizedTitle = @"IBAN";
    ibanElement.localizedTooltip = @"Please position IBAN in this field";
    ibanElement.scanningRegionHeight = 0.09;
    ibanElement.scanningRegionWidth = 0.8;
    [retArray addObject:ibanElement];
    
    PPDateOcrParserFactory *dateFactory = [[PPDateOcrParserFactory alloc] init];
    dateFactory.isRequired = NO;
    PPScanElement *dateElement = [[PPScanElement alloc] initWithIdentifier:@"Date" parserFactory:dateFactory];
    dateElement.localizedTitle = @"Date";
    dateElement.localizedTooltip = @"Please position date in this field";
    dateElement.scanningRegionHeight = 0.09;
    ibanElement.scanningRegionWidth = 0.8;
    [retArray addObject:dateElement];
    
    PPEmailOcrParserFactory *emailFactory = [[PPEmailOcrParserFactory alloc] init];
    emailFactory.isRequired = NO;
    PPScanElement *emailElement = [[PPScanElement alloc] initWithIdentifier:@"Email" parserFactory:emailFactory];
    emailElement.localizedTitle = @"Email";
    emailElement.localizedTooltip = @"Please position Email in this field";
    emailElement.scanningRegionHeight = 0.09;
    emailElement.scanningRegionWidth = 0.8;
    [retArray addObject:emailElement];
    
    PPVinOcrParserFactory *vinFactory = [[PPVinOcrParserFactory alloc] init];
    vinFactory.isRequired = NO;
    PPScanElement *vinElement = [[PPScanElement alloc] initWithIdentifier:@"IBAN" parserFactory:vinFactory];
    vinElement.localizedTitle = @"VIN";
    vinElement.localizedTooltip = @"Please position VIN in this field";
    vinElement.scanningRegionHeight = 0.09;
    vinElement.scanningRegionWidth = 0.8;
    [retArray addObject:vinElement];
    
    return retArray;
    
}

+ (NSArray *)getInitialParsers {
    NSMutableArray *retArray = [NSMutableArray array];
    PPRawOcrParserFactory *rawFactory = [[PPRawOcrParserFactory alloc] init];
    rawFactory.isRequired = NO;
    PPScanElement *rawElement = [[PPScanElement alloc] initWithIdentifier:@"Raw" parserFactory:rawFactory];
    rawElement.localizedTitle = @"Text";
    rawElement.localizedTooltip = @"Please position desired text in this field";
    rawElement.scanningRegionHeight = 0.14;
    rawElement.scanningRegionWidth = 0.8;
    [retArray addObject:rawElement];
    
    PPPriceOcrParserFactory *priceFactory = [[PPPriceOcrParserFactory alloc] init];
    priceFactory.isRequired = NO;
    PPScanElement *priceElement = [[PPScanElement alloc] initWithIdentifier:@"Price" parserFactory:priceFactory];
    priceElement.localizedTitle = @"Amount";
    priceElement.localizedTooltip = @"Please position amount in this field";
    priceElement.scanningRegionHeight = 0.09;
    priceElement.scanningRegionWidth = 0.5;
    [retArray addObject:priceElement];
    
    PPIbanOcrParserFactory *ibanFactory = [[PPIbanOcrParserFactory alloc] init];
    ibanFactory.isRequired = NO;
    PPScanElement *ibanElement = [[PPScanElement alloc] initWithIdentifier:@"IBAN" parserFactory:ibanFactory];
    ibanElement.localizedTitle = @"IBAN";
    ibanElement.localizedTooltip = @"Please position IBAN in this field";
    ibanElement.scanningRegionHeight = 0.09;
    ibanElement.scanningRegionWidth = 0.8;
    [retArray addObject:ibanElement];
    
    return retArray;
}

+ (BOOL)areSettingsAllowed {
    return YES;
}

@end
