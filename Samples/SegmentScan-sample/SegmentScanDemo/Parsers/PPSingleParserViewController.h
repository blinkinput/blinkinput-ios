//
//  PPSingleParserView.h
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPScanElement.h"
#import <UIKit/UIKit.h>

@protocol PPSingleParserViewControllerDelegate;

@interface PPSingleParserViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIButton *parser;

@property(nonatomic) PPScanElement *element;

@property(nonatomic) id<PPSingleParserViewControllerDelegate> delegate;

- (instancetype)initWithPPScanElement:(PPScanElement *)element;

@end

@protocol PPSingleParserViewControllerDelegate <NSObject>

- (void)userDidTapViewController:(PPSingleParserViewController *)viewController;

@end
