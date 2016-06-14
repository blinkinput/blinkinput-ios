//
//  PPTemplatingRecognizerSettings.h
//  PhotoPayFramework
//
//  Created by Dino on 18/05/16.
//  Copyright © 2016 MicroBlink Ltd. All rights reserved.
//

#import "PPRecognizerSettings.h"
#import "PPOcrParserFactory.h"
#import "PPDecodingInfo.h"

NS_ASSUME_NONNULL_BEGIN

PP_CLASS_AVAILABLE_IOS(6.0) @interface PPTemplatingRecognizerSettings : PPRecognizerSettings

@property (nonatomic) BOOL allowUnparsedResults;

- (void)addOcrParser:(PPOcrParserFactory *)factory name:(NSString *)name;

- (void)addOcrParser:(PPOcrParserFactory *)factory
                name:(NSString *)name
               group:(NSString *)group;

- (void)removeOcrParserWithName:(NSString *)name;

- (void)removeOcrParserWithName:(NSString *)parser fromGroup:(NSString *)group;

- (void)clearParsersInGroup:(NSString *)group;

- (void)clearAllParsers;

- (void)setDecodingInfoSet:(NSArray<PPDecodingInfo*> *)decodingInfos forClassifierResult:(NSString *)classifierResult;

- (void)removeDecodingInfoSetForClassifierResult:(NSString *)classifierResult;

- (void)removeAllDecodingInfoSets;

@end

NS_ASSUME_NONNULL_END
