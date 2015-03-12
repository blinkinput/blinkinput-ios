//
//  PPOcrParseElement.m
//  BlinkOCR
//
//  Created by Jura on 02/03/15.
//  Copyright (c) 2015 PhotoPay. All rights reserved.
//

#import "PPScanElement.h"

@implementation PPScanElement

- (instancetype)initWithIdentifier:(NSString*)identifier
                     parserFactory:(PPOcrParserFactory*)factory {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _factory = factory;
    }
    return self;
}

@end
