//
//  PPParserDetailViewController.h
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPScanElement.h"
#import <UIKit/UIKit.h>

@protocol PPParserDetailDelegate;

@interface PPParserDetailViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic) PPScanElement *element;

@property(nonatomic) id<PPParserDetailDelegate> delegate;

+ (instancetype)viewControllerFromStoryboard;

@end

@protocol PPParserDetailDelegate <NSObject>

- (void)parserDetailController:(PPParserDetailViewController *)parserDetailController didFinishEditingElement:(PPScanElement *)element;

- (void)parserDetailController:(PPParserDetailViewController *)parserDetailController didDeleteElement:(PPScanElement *)element;

@end
