//
//  PPFieldOverlayItemView.m
//  SegmentScanDemo
//
//  Created by Dino on 07/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPFieldItemViewController.h"

@interface PPFieldItemViewController ()

@property(weak, nonatomic) IBOutlet UIButton *buttonScan;
@property(weak, nonatomic) IBOutlet UIView *lineBottom;

@end

@implementation PPFieldItemViewController

- (instancetype)initWithScanElement:(PPScanElement *)element {
    if ((self = [[PPFieldItemViewController alloc] initWithNibName:@"PPFieldItemViewController" bundle:nil])) {
        _element = element;
    }
    return self;
}

- (void)viewDidLoad {
    self.textFieldValue.delegate = self;
    [self.textFieldValue setKeyboardType:self.element.keyboardType];
    self.textFieldValue.placeholder = self.element.localizedTitle;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.element.value = self.textFieldValue.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)hideBottomLine:(BOOL)hide {
    [self.lineBottom setHidden:hide];
}

- (void)hideKeyboard {
    [self.textFieldValue resignFirstResponder];
}

- (IBAction)buttonScanUserDidTap:(id)sender {
    [self.delegate buttonScanUserDidTapItem:self];
}

- (void)setTextFieldText:(NSString *)text {
    self.textFieldValue.text = text;
}

@end
