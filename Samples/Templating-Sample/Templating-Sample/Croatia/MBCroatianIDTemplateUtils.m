//
//  MBCroatianIDTemplateUtils.m
//  Showcase
//
//  Created by Jura Skrlec on 27/03/2018.
//  Copyright © 2018 MicroBlink Ltd. All rights reserved.
//

#import "MBCroatianIDTemplateUtils.h"

@implementation MBCroatianIDTemplateUtils

+ (NSMutableSet *)croatianCharsWhitelist {
    
    // initialize new char whitelist
    NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];
    
    // Add chars 'A'-'Z'
    for (int c = 'A'; c <= 'Z'; c++) {
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:c font:MB_OCR_FONT_ANY]];
    }
    
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:L'Š' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:L'Ž' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:L'Č' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:L'Ć' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:L'Đ' font:MB_OCR_FONT_ANY]];
    return charWhitelist;
}

@end
