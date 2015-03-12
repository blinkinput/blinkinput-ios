//
//  PPFormOcrOverlayViewController.m
//  BlinkOCR
//
//  Created by Jura on 01/03/15.
//  Copyright (c) 2015 PhotoPay. All rights reserved.
//

#import "PPFormOcrOverlayViewController.h"

#import <MicroBlink/PPModernOcrResultOverlaySubview.h>

#import "PPPivotView.h"
#import "PPScanResultView.h"
#import "PPScanElement.h"

#import "PPBlinkOcrHelpViewController.h"

CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

CGRect CGRectBounds(CGRect rect) {
    return CGRectMake(0, 0, rect.size.width, rect.size.height);
}

@interface PPFormOcrOverlayViewController () <PPPivotViewDelegate, PPBlinkOcrHelpViewControllerDelegate>

@property (nonatomic, strong) PPModernOcrResultOverlaySubview *ocrResultOverlaySubview;

@property (nonatomic, assign) BOOL lightOn;

@property (nonatomic, strong) PPPivotView *pivotView;

@property (nonatomic, strong) PPScanResultView *scanResultView;

@property (nonatomic, assign) NSUInteger currentElementIndex;

@property (nonatomic, strong) PPOcrRecognizerSettings* ocrRecognizerSettings;

@property (nonatomic, assign) SystemSoundID sound;

@end

@implementation PPFormOcrOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//     Add overlay subview which shows OCR precess
    self.ocrResultOverlaySubview = [[PPModernOcrResultOverlaySubview alloc] initWithFrame:self.view.frame];
    self.ocrResultOverlaySubview.shouldIgnoreFastResults = YES;
    [self addOverlaySubview:self.ocrResultOverlaySubview];

    // hide light if not available on device
    if (![self.containerViewController overlayViewControllerShouldDisplayTorch:self]) {
        self.buttonLight.enabled = NO;
        self.buttonLight.alpha = 0.0f;
    }

    // instantiate and setup Pivot view
    self.pivotView = [[PPPivotView alloc] initWithFrame:self.pivotViewContainer.bounds];
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
}

- (NSArray*)pivotViewTitles {
    NSMutableArray* titles = [[NSMutableArray alloc] initWithCapacity:self.scanElements.count];
    for (PPScanElement *element in self.scanElements) {
        [titles addObject:element.localizedTitle];
    }
    return titles;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.currentElementIndex = 0;

    PPScanElement *scanElement = ((PPScanElement*)[self.scanElements objectAtIndex:self.currentElementIndex]);
    scanElement.scanned = NO;
    scanElement.edited = NO;

    // setup scannig of first element
    self.ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];
    [self.ocrRecognizerSettings addOcrParser:scanElement.factory
                                        name:scanElement.identifier];
    [self.coordinator.currentSettings.scanSettings addRecognizerSettings:self.ocrRecognizerSettings];

    [self.coordinator applySettings];

    self.labelTooltip.text = scanElement.localizedTooltip;

    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

#if TARGET_IPHONE_SIMULATOR
    self.scanResultView.textField.text = @"123,22";

    [self showResultView];
#endif
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self updateScanningRegion];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {

    [UIView animateWithDuration:self.pivotView.moveAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scanResultView.center = CGRectCenter([self scanResultViewWithKeyboardFrame]);
                         self.scanResultView.bounds = CGRectBounds([self scanResultViewWithKeyboardFrame]);
                         self.scanResultView.backgroundColor = [self.scanResultView.backgroundColor colorWithAlphaComponent:1.0f];

                         self.ocrResultOverlaySubview.alpha = 0.0f;
                     } completion:nil];

    [[self containerViewController] pauseScanning];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {

    [UIView animateWithDuration:self.pivotView.moveAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scanResultView.center = CGRectCenter([self scanResultViewFrame]);
                         self.scanResultView.bounds = CGRectBounds([self scanResultViewFrame]);
                         self.scanResultView.backgroundColor = [self.scanResultView.backgroundColor colorWithAlphaComponent:0.7f];

                         self.ocrResultOverlaySubview.alpha = 1.0f;
                     } completion:nil];

    PPScanElement *scanElement = ((PPScanElement*)[self.scanElements objectAtIndex:self.currentElementIndex]);
    scanElement.edited = YES;
    scanElement.scanned = NO;
    scanElement.value = self.scanResultView.textField.text;

    [[self containerViewController] resumeScanningWithoutStateReset];
}

- (void)updateScanningRegion {

    CGFloat regionMargin = 10.f;

    CGFloat left = self.viewfinder.frame.origin.x + regionMargin;
    CGFloat top = self.viewfinder.frame.origin.y + regionMargin;
    CGFloat width = self.viewfinder.frame.size.width - 2 * regionMargin;
    CGFloat height = self.viewfinder.frame.size.height - 2 * regionMargin;

    self.scanningRegion = CGRectMake(left / self.view.frame.size.width,
                                     top / self.view.frame.size.height,
                                     width / self.view.frame.size.width,
                                     height / self.view.frame.size.height);

    [self.containerViewController updateScanningRegion];
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - instantiation

+ (instancetype)allocFromNibName:(NSString*)nibName {
    PPFormOcrOverlayViewController *vc = [[PPFormOcrOverlayViewController alloc] initWithNibName:nibName bundle:nil];
    return vc;
}

#pragma mark - UI interaction

- (IBAction)didPressClose:(id)sender {
    [self.delegate formOcrOverlayViewControllerWillClose:self];
}

- (IBAction)didPressLight:(id)sender {
    self.lightOn ^= [[self containerViewController] overlayViewController:self
                                                             willSetTorch:!self.lightOn];
    self.buttonLight.selected = self.lightOn;
}

- (IBAction)didPressHelp:(id)sender {
    PPBlinkOcrHelpViewController* helpVC = [PPBlinkOcrHelpViewController allocFromStoryboardWithName:@"PPBlinkOcrHelp"];
    helpVC.delegate = self;
    helpVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:helpVC animated:YES completion:nil];
}

- (IBAction)didTapNext:(id)sender {

    PPScanElement *scanElement = ((PPScanElement*)[self.scanElements objectAtIndex:self.currentElementIndex]);

    scanElement.value = self.scanResultView.textField.text;

    if (self.currentElementIndex < self.scanElements.count - 1) {
        [self.pivotView moveForward];
    } else {
        [self.delegate formOcrOverlayViewController:self
                      didFinishScanningWithElements:self.scanElements];
    }
}

#pragma mark - PPBlinkOcrHelpViewControllerDelegate

- (void)blinkOcrHelpViewControllerDelegateWillClose:(PPBlinkOcrHelpViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PPPivotViewDelegate

- (void)pivotView:(PPPivotView *)pivotView willSelectIndex:(NSUInteger)index {

    PPScanElement *scanElement = ((PPScanElement*)[self.scanElements objectAtIndex:index]);

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

    PPScanElement *scanElement = ((PPScanElement*)[self.scanElements objectAtIndex:self.currentElementIndex]);
    
    [self.ocrRecognizerSettings removeOcrParserWithName:scanElement.identifier];

    self.currentElementIndex = index;

    scanElement = ((PPScanElement*)[self.scanElements objectAtIndex:self.currentElementIndex]);
    [self.ocrRecognizerSettings addOcrParser:scanElement.factory
                                        name:scanElement.identifier];

    scanElement.scanned = NO;
    scanElement.edited = NO;

    [self.coordinator applySettings];
}

#pragma mark - OverlayViewController stuff

- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
            didOutputResults:(NSArray *)results {

    for (PPBaseResult* result in results) {
        if ([result isKindOfClass:[PPOcrScanResult class]]) {
            PPOcrScanResult *ocrScanResult = (PPOcrScanResult*)result;
            [self processOcrScanResult:ocrScanResult];
        }
    }
}

- (void)processOcrScanResult:(PPOcrScanResult*)result {

    PPScanElement *element = ((PPScanElement*)[self.scanElements objectAtIndex:self.currentElementIndex]);

    if (element.edited) {
        return;
    }

    NSString *val = [result parsedResultForName:element.identifier];

    if (val == nil || [val length] == 0) {
        return;
    }

    element.value = val;

    if (!element.scanned) {
        element.scanned = YES;

        [self playResultSound];

        self.scanResultView.textField.text = val;

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

    return CGRectMake(margin, top,
                      self.view.frame.size.width - 2 * margin,
                      self.view.frame.size.height - top - margin);
}

- (CGRect)scanResultViewWithKeyboardFrame {
    CGFloat margin = 20;
    CGFloat top = self.pivotViewContainer.center.y + self.pivotView.frame.size.height / 2;

    return CGRectMake(margin, top,
                      self.view.frame.size.width - 2 * margin,
                      self.view.frame.size.height - margin - top);
}

- (void)showResultView {

    [self.scanResultView animateShowFromPoint:self.viewfinder.center
                                     toBounds:CGRectBounds([self scanResultViewFrame])
                                       center:CGRectCenter([self scanResultViewFrame])
                            animationDuration:0.3
                                   completion:^(BOOL finished) {
                                       self.scanResultView.userInteractionEnabled = YES;
                                   }];
}

- (void)hideResultView {

    [self.scanResultView.textField endEditing:YES];

    self.scanResultView.userInteractionEnabled = NO;

    [self.scanResultView animateHideToPoint:self.buttonNext.center
                          animationDuration:0.3
                                 completion:nil];
}

#pragma mark - Play system sound

- (void)playResultSound {
    if (!self.sound) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PPbeep" ofType:@"wav"]], &_sound);
    }

    AudioServicesPlaySystemSound(self.sound);
}

@end
