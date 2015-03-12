//
//  PPOcrScanResult.h
//  PhotoPayFramework
//
//  Created by Jura on 18/09/14.
//  Copyright (c) 2014 MicroBlink Ltd. All rights reserved.
//

#import "PPBaseResult.h"
#import "PPOcrResult.h"

@interface PPOcrScanResult : PPBaseResult

/**
 * Designated initializer for this class
 *
 *  @param recognitionResult Recognition result private implementation
 *
 *  @return initialized OCR scan result
 */
- (instancetype)initWithRecognitionResult:(struct RecognitionResultImpl *)recognitionResult;

/**
 * If only default parser group is used, this method returns the OCR result for this parser group
 *
 *  @return OCR result for default parser group
 */
- (PPOcrResult*)ocrResult;

/**
 * If only default parser group is used, this method returns parsed string from the defaul parser group
 *
 *  @param name name of the parser responsible for parsing the wanted string
 *
 *  @return parsed string
 */
- (NSString*)parsedResultForName:(NSString*)name;

/**
 * Retrieves OCR result from arbitrary parser groups
 *
 *  @param parserGroup parser group name
 *
 *  @return OCR result for given parser group
 */
- (PPOcrResult*)ocrResultForParserGroup:(NSString*)parserGroup;

/**
 *  Retrieves parsed string from given parser group
 *
 *  @param name        name of the parser responsible for parsing the wanted string
 *  @param parserGroup parser group name
 *
 *  @return parsed string
 */
- (NSString*)parsedResultForName:(NSString*)name parserGroup:(NSString*)parserGroup;

@end
