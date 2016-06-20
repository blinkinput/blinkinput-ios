//
//  PPParserDetailViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPParserDetailViewController.h"

@interface PPParserDetailViewController ()

@property(weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property(weak, nonatomic) IBOutlet UITextField *textFieldTooltip;
@property(weak, nonatomic) IBOutlet UITextField *textFieldType;
@property(weak, nonatomic) IBOutlet UITextField *textFieldKeyboardText;
@property (weak, nonatomic) IBOutlet UITextField *textFieldScanningHeight;
@property (weak, nonatomic) IBOutlet UITextField *textFieldScanningWidth;

@end

@implementation PPParserDetailViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelectedParsersStoryboard" bundle:nil];
    PPParserDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PPParserDetailViewController"];
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.textFieldTitle.text = self.element.localizedTitle;
    self.textFieldTooltip.text = self.element.localizedTooltip;
    self.textFieldKeyboardText.text = self.element.localizedTextfieldText;
    self.textFieldScanningHeight.text = [NSString stringWithFormat:@"%0.2f", self.element.scanningRegionHeight];
    self.textFieldScanningWidth.text = [NSString stringWithFormat:@"%0.2f", self.element.scanningRegionWidth];
    self.textFieldType.text = NSStringFromClass([self.element.factory class]);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textFieldTitle) {
        self.element.localizedTitle = self.textFieldTitle.text;
    } else if (textField == self.textFieldTooltip) {
        self.element.localizedTooltip = self.textFieldTooltip.text;
    } else if (textField == self.textFieldKeyboardText) {
        self.element.localizedTextfieldText = self.textFieldKeyboardText.text;
    } else if (textField == self.textFieldScanningHeight) {
        self.element.scanningRegionHeight = [self.textFieldScanningHeight.text floatValue];
    } else if (textField == self.textFieldScanningWidth) {
        self.element.scanningRegionHeight = [self.textFieldScanningWidth.text floatValue];
    } else {
        // TODO: Error
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.element.localizedTitle = self.textFieldTitle.text;
    self.element.localizedTooltip = self.textFieldTooltip.text;
    [self.delegate parserDetailController:self didFinishEditingElement:self.element];
    [super viewWillDisappear:animated];
}

- (IBAction)buttonDeleteDidTap:(id)sender {
    [self.delegate parserDetailController:self didDeleteElement:self.element];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
