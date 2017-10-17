//
//  PPFormOcrOverlayViewController.m
//  BlinkOCR
//
//  Created by Jura on 01/03/15.
//  Copyright (c) 2015 PhotoPay. All rights reserved.
//

#import "PPFormOcrOverlayViewController.h"

#import <MicroBlink/PPModernOcrResultOverlaySubview.h>
#import <MicroBlink/PPBlinkOcrRecognizerResult.h>

#import "PPPivotView.h"
#import "PPScanElement.h"
#import "PPScanResultView.h"

#import "PPBlinkOcrHelpViewController.h"

CGPoint CGRectCenter(CGRect rect) { return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2); }

CGRect CGRectBounds(CGRect rect) { return CGRectMake(0, 0, rect.size.width, rect.size.height); }

@interface PPFormOcrOverlayViewController () <PPPivotViewDelegate, PPBlinkOcrHelpViewControllerDelegate>

@property(nonatomic, strong) PPModernOcrResultOverlaySubview *ocrResultOverlaySubview;

@property(nonatomic, assign) BOOL lightOn;

@property(nonatomic, strong) PPPivotView *pivotView;

@property(nonatomic, strong) PPScanResultView *scanResultView;

@property(nonatomic, assign) NSUInteger currentElementIndex;

@property(nonatomic, strong) PPBlinkInputRecognizerSettings *ocrRecognizerSettings;

@property(nonatomic, assign) SystemSoundID sound;

@property(nonatomic) NSMutableArray<NSLayoutConstraint *> *currentConstraints;

@property(weak, nonatomic) IBOutlet UILabel *labelNextButton;

@property(nonatomic) BOOL movingPivotView;

@end

@implementation PPFormOcrOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.movingPivotView = NO;

    //     Add overlay subview which shows OCR precess
    self.ocrResultOverlaySubview = [[PPModernOcrResultOverlaySubview alloc] initWithFrame:self.view.frame];
    self.ocrResultOverlaySubview.shouldIgnoreFastResults = YES;
    [self.view addSubview:self.ocrResultOverlaySubview];
    [self registerOverlaySubview:self.ocrResultOverlaySubview];

    // instantiate and setup Pivot view
    self.pivotView = [[PPPivotView alloc] initWithFrame:self.pivotViewContainer.bounds];
    if (self.scanElements.count < 3 || self.scanElements.count > 3)
        self.pivotView.centered = YES;
    self.pivotView.delegate = self;

    self.pivotView.titles = [self pivotViewTitles];
    self.pivotView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.pivotView update];

    [self.pivotViewContainer addSubview:self.pivotView];

    // instantiate and hide result view
    self.scanResultView = [PPScanResultView allocFromNibName:@"PPScanResultView"];
    self.scanResultView.hidden = YES;
    self.scanResultView.alpha = 0.0f;
    self.scanResultView.userInteractionEnabled = NO;

    [self.view insertSubview:self.scanResultView belowSubview:self.buttonNext];

    self.currentConstraints = [NSMutableArray array];

    self.currentElementIndex = 0;

    PPScanElement *scanElement = ((PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex]);
    scanElement.scanned = NO;
    scanElement.edited = NO;

    // set the keyboard type on scan result view
    self.scanResultView.textField.keyboardType = scanElement.keyboardType;

    // setup scannig of first element
    for (PPRecognizerSettings *settings in self.coordinator.currentSettings.scanSettings.recognizerSettingsList) {
        [self.coordinator.currentSettings.scanSettings removeRecognizerSettings:settings];
    }
    self.ocrRecognizerSettings = [[PPBlinkInputRecognizerSettings alloc] init];
    [self.ocrRecognizerSettings addOcrParser:scanElement.factory name:scanElement.identifier];
    [self.coordinator.currentSettings.scanSettings addRecognizerSettings:self.ocrRecognizerSettings];

    [self.coordinator applySettings];

    self.labelTooltip.text = scanElement.localizedTooltip;

    [self registerForKeyboardNotifications];
}

- (NSArray *)pivotViewTitles {
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:self.scanElements.count];
    for (PPScanElement *element in self.scanElements) {
        [titles addObject:element.localizedTitle];
    }
    return titles;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateScanningRegion];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // hide light if not available on device
    if (![self.containerViewController overlayViewControllerShouldDisplayTorch:self]) {
        self.buttonLight.enabled = NO;
        self.buttonLight.alpha = 0.0f;
    }

#if TARGET_IPHONE_SIMULATOR
    self.scanResultView.textField.text = @"123,22";

    [self showResultView];
#endif
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {

    [UIView animateWithDuration:self.pivotView.moveAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       self.scanResultView.center = CGRectCenter([self scanResultViewWithKeyboardFrame]);
                       self.scanResultView.bounds = CGRectBounds([self scanResultViewWithKeyboardFrame]);
                       self.scanResultView.backgroundColor = [self.scanResultView.backgroundColor colorWithAlphaComponent:1.0f];

                       self.ocrResultOverlaySubview.alpha = 0.0f;
                     }
                     completion:nil];

    [[self containerViewController] pauseScanning];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {

    [UIView animateWithDuration:self.pivotView.moveAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       self.scanResultView.center = CGRectCenter([self scanResultViewFrame]);
                       self.scanResultView.bounds = CGRectBounds([self scanResultViewFrame]);
                       self.scanResultView.backgroundColor = [self.scanResultView.backgroundColor colorWithAlphaComponent:0.7f];

                       self.ocrResultOverlaySubview.alpha = 1.0f;
                     }
                     completion:nil];

    PPScanElement *scanElement = ((PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex]);
    scanElement.edited = YES;
    scanElement.scanned = NO;
    scanElement.value = self.scanResultView.textField.text;

    [[self containerViewController] resumeScanningAndResetState:NO];
}

- (void)updateScanningRegion {

    PPScanElement *currentElement = (PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex];

    CGFloat borderWidth = self.view.bounds.size.width * currentElement.scanningRegionWidth;
    CGFloat xMargin = (self.view.bounds.size.width - borderWidth) / 2;

    [self.view layoutIfNeeded];

    for (NSLayoutConstraint *constraint in self.currentConstraints) {
        [self.view removeConstraint:constraint];
    }
    [self.currentConstraints removeAllObjects];

    [self.currentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.viewfinder
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:currentElement.scanningRegionHeight
                                                                     constant:0.0]];
    [self.currentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.viewfinder
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:xMargin]];
    [self.currentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.viewfinder
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:-xMargin]];

    for (NSLayoutConstraint *constraint in self.currentConstraints) {
        [self.view addConstraint:constraint];
    }

    [UIView animateWithDuration:0.5
                     animations:^{
                       [self.view layoutIfNeeded];
                     }];

    self.scanningRegion = CGRectMake(
        (self.viewfinder.frame.origin.x + 10) / self.view.frame.size.width, (self.viewfinder.frame.origin.y + 10) / self.view.frame.size.height,
        (self.viewfinder.frame.size.width - 20) / self.view.frame.size.width, (self.viewfinder.frame.size.height - 20) / self.view.frame.size.height);
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - instantiation

+ (instancetype)allocFromNibName:(NSString *)nibName {
    PPFormOcrOverlayViewController *vc = [[PPFormOcrOverlayViewController alloc] initWithNibName:nibName bundle:nil];
    return vc;
}

#pragma mark - UI interaction

- (IBAction)didPressClose:(id)sender {
    [self.delegate formOcrOverlayViewControllerWillClose:self];
}

- (IBAction)didPressLight:(id)sender {
    self.lightOn ^= [[self containerViewController] overlayViewController:self willSetTorch:!self.lightOn];
    self.buttonLight.selected = self.lightOn;
}

- (IBAction)didPressHelp:(id)sender {
    PPBlinkOcrHelpViewController *helpVC = [PPBlinkOcrHelpViewController allocFromStoryboardWithName:@"PPBlinkOcrHelp"];
    helpVC.delegate = self;
    helpVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:helpVC animated:YES completion:nil];
}

- (IBAction)didTapNext:(id)sender {

    PPScanElement *scanElement = ((PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex]);

    scanElement.value = self.scanResultView.textField.text;
    self.scanResultView.textField.text = @"";

    if (self.currentElementIndex < self.scanElements.count - 1) {
        [self.pivotView moveForward];
    } else {
        [self.delegate formOcrOverlayViewController:self didFinishScanningWithElements:self.scanElements];
    }
}

#pragma mark - PPBlinkOcrHelpViewControllerDelegate

- (void)blinkOcrHelpViewControllerDelegateWillClose:(PPBlinkOcrHelpViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PPPivotViewDelegate

- (void)pivotView:(PPPivotView *)pivotView willSelectIndex:(NSUInteger)index {

    self.buttonNext.userInteractionEnabled = NO;
    self.movingPivotView = YES;

    PPScanElement *scanElement = ((PPScanElement *)[self.scanElements objectAtIndex:index]);
    self.buttonSkip.enabled = YES;
    self.buttonSkip.hidden = NO;
    self.buttonNext.enabled = NO;
    self.buttonNext.hidden = YES;
    self.labelNextButton.text = @"Skip";

    [UIView transitionWithView:self.labelTooltip
                      duration:self.pivotView.moveAnimationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.labelTooltip.text = scanElement.localizedTooltip;
                    }
                    completion:nil];

    [self hideResultView];
}

- (void)pivotView:(PPPivotView *)pivotView didSelectIndex:(NSUInteger)index {

    self.buttonNext.userInteractionEnabled = YES;
    self.movingPivotView = NO;

    PPScanElement *scanElement = ((PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex]);

    [self.ocrRecognizerSettings removeOcrParserWithName:scanElement.identifier];

    self.currentElementIndex = index;

    scanElement = ((PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex]);
    [self.ocrRecognizerSettings addOcrParser:scanElement.factory name:scanElement.identifier];

    scanElement.scanned = NO;
    scanElement.edited = NO;

    self.scanResultView.textField.keyboardType = scanElement.keyboardType;

    [self updateScanningRegion];

    [self.coordinator applySettings];
}

#pragma mark - OverlayViewController stuff

- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController didOutputResults:(NSArray *)results {

    for (PPRecognizerResult *result in results) {
        if ([result isKindOfClass:[PPBlinkInputRecognizerResult class]]) {
            PPBlinkInputRecognizerResult *ocrRecognizerResult = (PPBlinkInputRecognizerResult *)result;
            [self processOcrRecognizerResult:ocrRecognizerResult];
        }
    }
}

- (void)processOcrRecognizerResult:(PPBlinkInputRecognizerResult *)ocrRecognizerResult {

    if (self.movingPivotView) {
        return;
    }

    PPScanElement *element = ((PPScanElement *)[self.scanElements objectAtIndex:self.currentElementIndex]);

    if (element.edited) {
        return;
    }

    NSString *val = [ocrRecognizerResult parsedResultForName:element.identifier];
    NSRange  searchedRange = NSMakeRange(0, [val length]);
    
    if ([element.identifier isEqualToString:kVersicherungsnummer]) {
        
        NSString *pattern = @"([0-9]{2}\\s[0-9]{6}\\s[A-Z]{1}\\s[0-9]{3})";
        NSError  *error = nil;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:val options:0 range: searchedRange];
        val = [[val substringWithRange:[match rangeAtIndex:1]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    else if ([element.identifier isEqualToString:kRente]) {
        NSString *pattern = @"(\\d+\\.?\\d+,?\\d*\\sEUR)";
        NSError  *error = nil;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        if (val.length > 0) {
            NSArray* matches = [regex matchesInString:val options:0 range: searchedRange];
            
            if (matches.count == 3) {
                NSMutableArray *values = [NSMutableArray new];
                for (NSTextCheckingResult* match in matches) {
                    NSString* matchText = [val substringWithRange:[match range]];
                    NSLog(@"Match: %@", matchText);
                    NSRange valueRange = [match rangeAtIndex:1];
                    NSLog(@"Value: %@", [val substringWithRange:valueRange]);
                    NSString *eurRenten = [val substringWithRange:valueRange];
                    [values addObject:[eurRenten stringByReplacingOccurrencesOfString:@" EUR" withString:@""]];
                }
                
                element.multipleValues = values.copy;
            }
        }
    }

    // Group IBAN characters into groups of 4
    if ([element.factory class] == [PPIbanOcrParserFactory class]) {
        NSMutableString *separatedIban = [val mutableCopy];
        for (int i = 0; i < val.length; i += 4) {
            [separatedIban insertString:@" " atIndex:i + i / 4];
        }
        val = separatedIban;
    }


    if (val == nil || [val length] == 0) {
        return;
    }

    element.value = val;

    if (!element.scanned) {
        element.scanned = YES;


        self.scanResultView.textField.text = val;

        self.buttonSkip.enabled = NO;
        self.buttonSkip.hidden = YES;
        self.buttonNext.enabled = YES;
        self.buttonNext.hidden = NO;
        self.labelNextButton.text = @"Continue";
        self.scanResultView.labelResultTitle.text = element.localizedTitle;

        [self showResultView];
    } else {
        if ([self.scanResultView.textField.text isEqualToString:val]) {
            return;
        }

        [UIView transitionWithView:self.scanResultView.textField
                          duration:self.pivotView.moveAnimationDuration / 2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                          self.scanResultView.textField.text = val;
                        }
                        completion:nil];
    }
}

#pragma mark - UI stuff when displaying result

- (CGRect)scanResultViewFrame {

    CGFloat margin = 20;
    CGFloat top = self.viewfinder.frame.origin.y + self.viewfinder.frame.size.height + 2 * margin;

    return CGRectMake(margin, top, self.view.frame.size.width - 2 * margin, self.view.frame.size.height - top - margin);
}

- (CGRect)scanResultViewWithKeyboardFrame {
    CGFloat margin = 20;
    CGFloat top = self.pivotViewContainer.center.y + self.pivotView.frame.size.height / 2;

    return CGRectMake(margin, top, self.view.frame.size.width - 2 * margin, self.view.frame.size.height - margin - top);
}

- (void)showResultView {

    [self.scanResultView animateShowFromViewCenter:self.viewfinder
                                           toFrame:self.resultViewPlaceholder
                                 animationDuration:0.3
                                        completion:^(BOOL finished) {
                                          self.scanResultView.userInteractionEnabled = YES;
                                        }];
}

- (void)hideResultView {

    [self.scanResultView.textField endEditing:YES];

    self.scanResultView.userInteractionEnabled = NO;

    [self.scanResultView animateHideToViewCenter:self.buttonNext animationDuration:0.3 completion:nil];
}

#pragma mark - Autorotation

// If settings.uiSettings.autorotateOverlay is set to YES, this method defines supported orientations.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
