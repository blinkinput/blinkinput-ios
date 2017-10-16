//
//  PPFieldOverlayItemView.h
//  SegmentScanDemo
//
//  Created by Dino on 07/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPScanElement.h"
#import <UIKit/UIKit.h>

@protocol PPFieldOverlayItemViewControllerDelegate;

@interface PPFieldItemViewController : UIViewController <UITextFieldDelegate>

- (instancetype)initWithScanElement:(PPScanElement *)element;

@property(nonatomic) PPScanElement *element;

@property(weak, nonatomic) IBOutlet UITextField *textFieldValue;

@property(nonatomic, weak) id<PPFieldOverlayItemViewControllerDelegate> delegate;

- (void)hideBottomLine:(BOOL)hide;

- (void)hideKeyboard;

@end

@protocol PPFieldOverlayItemViewControllerDelegate <NSObject>

- (void)buttonScanUserDidTapItem:(PPFieldItemViewController *)itemViewController;

@end
