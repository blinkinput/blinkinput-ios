//
//  PPAvailableParsersViewController.h
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPSingleParserViewController.h"
#import <UIKit/UIKit.h>

@protocol PPAvailableParsersDelegate;

@interface PPAvailableParsersViewController : UIViewController <PPSingleParserViewControllerDelegate>

@property(nonatomic) id<PPAvailableParsersDelegate> delegate;

+ (instancetype)viewControllerFromStoryboard;

@end

@protocol PPAvailableParsersDelegate <NSObject>

- (void)userDidSelectScanElement:(PPScanElement *)element;

@end
