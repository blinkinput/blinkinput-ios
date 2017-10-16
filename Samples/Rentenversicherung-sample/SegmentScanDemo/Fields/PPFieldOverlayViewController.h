//
//  PPFieldOverlayViewController.h
//  SegmentScanDemo
//
//  Created by Dino on 08/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPScanElement.h"
#import <MicroBlink/MicroBlink.h>
#import <MicroBlink/PPBaseOverlayViewController.h>
#import <UIKit/UIKit.h>

@interface PPFieldOverlayViewController : PPBaseOverlayViewController

@property(nonatomic) PPScanElement *element;

@property(weak, nonatomic) IBOutlet UILabel *labelTooltip;

@property(weak, nonatomic) IBOutlet UILabel *labelTitle;

+ (instancetype)viewControllerFromStoryboardWithElement:(PPScanElement *)element;

@end
