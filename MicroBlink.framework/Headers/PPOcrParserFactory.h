//
//  PPOcrParserFactory.h
//  PhotoPayFramework
//
//  Created by Jura on 26/02/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"

NS_ASSUME_NONNULL_BEGIN

struct OcrParserFactoryImpl;
typedef struct OcrParserFactoryImpl OcrParserFactoryImpl;

PP_CLASS_AVAILABLE_IOS(6.0) @interface PPOcrParserFactory : NSObject

@property (nonatomic, readonly, assign) OcrParserFactoryImpl *factory;

- (instancetype)initWithFactory:(struct OcrParserFactoryImpl *)factory;

@property (nonatomic) BOOL isRequired;

@end

NS_ASSUME_NONNULL_END