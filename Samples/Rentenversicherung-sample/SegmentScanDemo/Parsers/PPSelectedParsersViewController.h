//
//  SelectedParsersViewController.h
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPAvailableParsersViewController.h"
#import "PPParserDetailViewController.h"
#import "PPSingleParserViewController.h"
#import <UIKit/UIKit.h>

@interface PPSelectedParsersViewController : UIViewController <PPSingleParserViewControllerDelegate, PPParserDetailDelegate, PPAvailableParsersDelegate>

@property(nonatomic) NSMutableArray *scanElements;
@property(nonatomic) NSMutableArray *scanElementViews;

+ (instancetype)viewControllerFromStoryboard;

@end
