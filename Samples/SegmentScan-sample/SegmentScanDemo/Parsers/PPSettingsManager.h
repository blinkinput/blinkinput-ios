//
//  PPSettingsManager.h
//  SegmentScanDemo
//
//  Created by Dino on 21/01/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPScanElement;

@interface PPSettingsManager : NSObject

+(NSMutableArray<PPScanElement*>*) getScanElements;

+(void) saveScanElements: (NSMutableArray<PPScanElement*>*) scanElements;

@end
