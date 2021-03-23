//
//  MBLogger.h
//  PhotoMathFramework
//
//  Created by Marko Mihovilić on 23/03/16.
//  Copyright © 2016 Microblink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"

typedef NS_ENUM(NSInteger, MBINLogLevel) {
    MBINLogLevelError,
    MBINLogLevelWarning,
    MBINLogLevelInfo,
    MBINLogLevelDebug,
    MBINLogLevelVerbose
};

@protocol MBINLoggerDelegate <NSObject>

@optional

- (void)log:(MBINLogLevel)level message:(const char *)message;
- (void)log:(MBINLogLevel)level format:(const char *)format arguments:(const char *)arguments;

@end

MB_CLASS_AVAILABLE_IOS(8.0) @interface MBINLogger : NSObject

@property (nonatomic) id<MBINLoggerDelegate> delegate;

+ (instancetype)sharedInstance NS_SWIFT_NAME(shared());

- (void)disableMicroblinkLogging;

@end
