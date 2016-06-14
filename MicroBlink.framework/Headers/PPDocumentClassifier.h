//
//  PPDocumentClassifier.h
//  PhotoPayFramework
//
//  Created by Dino on 19/05/16.
//  Copyright © 2016 MicroBlink Ltd. All rights reserved.
//

#import "PPMicroBlinkDefines.h"
#import "PPTemplatingRecognizerResult.h"

@protocol PPDocumentClassifier <NSObject>

- (NSString *)classifyDocumentFromResult:(PPTemplatingRecognizerResult *)result;

@end
