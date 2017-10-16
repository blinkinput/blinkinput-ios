//
//  PPParsers.h
//  SegmentScanDemo
//
//  Created by Dino on 31/03/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPParsers : NSObject

+ (NSArray *)getAvailableParsers;

+ (NSArray *)getInitialParsers;

+ (BOOL)areSettingsAllowed;

@end
