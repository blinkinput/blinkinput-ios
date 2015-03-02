//
//  PPOcrParserFactory.h
//  PhotoPayFramework
//
//  Created by Jura on 26/02/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

struct OcrParserFactoryImpl;
typedef struct OcrParserFactoryImpl OcrParserFactoryImpl;

@interface PPOcrParserFactory : NSObject

@property (nonatomic, readonly, assign) OcrParserFactoryImpl *factory;

- (instancetype)initWithFactory:(struct OcrParserFactoryImpl *)factory;

@end
