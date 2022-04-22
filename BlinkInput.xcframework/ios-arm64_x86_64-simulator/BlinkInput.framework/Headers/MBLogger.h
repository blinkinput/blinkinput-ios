//
//  MBLogger.h
//  PhotoMathFramework
//
//  Created by Marko Mihovilić on 23/03/16.
//  Copyright © 2016 Microblink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"

typedef NS_ENUM(NSInteger, MBILogLevel) {
    MBILogLevelError,
    MBILogLevelWarning,
    MBILogLevelInfo,
    MBILogLevelDebug,
    MBILogLevelVerbose
};

@protocol MBILoggerDelegate <NSObject>

@optional

- (void)log:(MBILogLevel)level message:(const char *)message;
- (void)log:(MBILogLevel)level format:(const char *)format arguments:(const char *)arguments;

@end

MB_CLASS_AVAILABLE_IOS(8.0) @interface MBILogger : NSObject

@property (nonatomic) id<MBILoggerDelegate> delegate;

+ (instancetype)sharedInstance NS_SWIFT_NAME(shared());

- (void)disableMicroblinkLogging;

@end
