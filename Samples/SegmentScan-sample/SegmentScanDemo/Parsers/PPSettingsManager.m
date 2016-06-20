//
//  PPSettingsManager.m
//  SegmentScanDemo
//
//  Created by Dino on 21/01/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "PPSettingsManager.h"
#import "PPScanElement.h"

@interface PPSettingsManager ()

@end

@implementation PPSettingsManager

static NSString *scanElementsKey = @"_scanElements";

+(NSMutableArray<PPScanElement*>*) getScanElements {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:scanElementsKey];
    NSMutableArray<PPScanElement*>* scanElements = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [[NSMutableArray alloc] initWithArray:scanElements];
}

+(void) saveScanElements: (NSMutableArray<PPScanElement*>*) scanElements {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:scanElements] forKey:scanElementsKey];
    [defaults synchronize];
}

@end
