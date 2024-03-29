//
//  MBTemplatingRecognizer.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/03/2018.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBRecognizer.h"
#import "MBTemplatingRecognizerResult.h"
#import "MBMicroblinkInitialization.h"

@class MBITemplatingClass;

NS_ASSUME_NONNULL_BEGIN

/**
 * Base of all recognizers that support Templating API.
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBITemplatingRecognizer : MBIRecognizer

MB_INIT_UNAVAILABLE

/**
 * Templating recognizer result
 */
@property (nonatomic, strong, readonly) MBITemplatingRecognizerResult *templatingResult;

/**
 * Defines if glare detection should be turned on/off for Templating Recognizer.
 *
 * Default: YES
 */
@property (nonatomic, assign) BOOL useGlareDetector;

/**
 * Returns all available templating classes
 */
@property (nonatomic, strong, nullable, readonly) NSArray<__kindof MBITemplatingClass *> *templatingClasses;

/**
 * Sets zero or more MBITemplatingClass that will try to be matched against document that
 * is being recognized.
 * @param templatingClasses Zero or more MBITemplatingClass objects representing specific class of documents.
 */
- (void)setTemplatingClasses:(nullable NSArray<__kindof MBITemplatingClass *> *)templatingClasses;

@end

NS_ASSUME_NONNULL_END
