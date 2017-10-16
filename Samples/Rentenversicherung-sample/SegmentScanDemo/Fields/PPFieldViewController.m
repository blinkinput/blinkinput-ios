//
//  PPFieldOcrOverlayViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 07/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPFieldOverlayViewController.h"
#import "PPFieldViewController.h"
#import <MicroBlink/PPBlinkOcrRecognizerResult.h>
#import <QuartzCore/QuartzCore.h>

@interface PPFieldViewController ()

@property(weak, nonatomic) IBOutlet UIView *scrollViewContent;

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(weak, nonatomic) IBOutlet UIView *cameraOverlayContainer;

@property(weak, nonatomic) IBOutlet UIView *paymentDetailsView;


@property(nonatomic) NSMutableArray *scanElementViews;

@property(nonatomic) UIViewController<PPScanningViewController> *scanningViewController;

@property(nonatomic) PPScanElement *currentElement;

@property(weak, nonatomic) PPFieldItemViewController *currentElementView;

@property(nonatomic) PPBlinkInputRecognizerSettings *settings;

@property(nonatomic) PPFieldOverlayViewController *overlay;

@property(nonatomic) NSLayoutConstraint *overlayShown;

@property(nonatomic) NSLayoutConstraint *preAnimation;

@end

@implementation PPFieldViewController

float const itemViewHeight = 50.0;
float const itemViewBottomMargin = 0.0;
float const itemViewTrailingMargin = 16.0;
float const itemViewleadingMargin = 16.0;
float const topItemTopMargin = 8.0;
float const bottomItemBottomMargin = 8.0;

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PPFieldViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PPFieldViewController"];
    return controller;
}

- (void)viewDidLoad {
    self.scanElementViews = [NSMutableArray array];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PPFieldItemViewController *lastSingleItem;
    [self.scrollViewContent setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingNone];
    self.cameraOverlayContainer.layer.masksToBounds = NO;
    self.cameraOverlayContainer.layer.shadowOffset = CGSizeMake(0, 0.f);
    self.cameraOverlayContainer.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.cameraOverlayContainer.layer.shadowRadius = 5.0f;
    self.cameraOverlayContainer.layer.shadowOpacity = 1.0f;
    self.scrollView.layer.shadowOffset = CGSizeMake(0, 5.f);
    self.scrollView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.scrollView.layer.shadowRadius = 5.0f;
    self.scrollView.layer.shadowOpacity = 1.0f;
    for (UIView *child in [self.scrollViewContent subviews]) {
        [child removeConstraints:child.constraints];
        [child removeFromSuperview];
    }
    int i = 0;
    for (PPScanElement *element in self.scanElements) {
        PPFieldItemViewController *item = [[PPFieldItemViewController alloc] initWithScanElement:element];
        [item.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        item.delegate = self;
        [self addChildViewController:item];
        [self.scrollViewContent addSubview:item.view];
        [item didMoveToParentViewController:self];
        [self.scrollViewContent addConstraint:[NSLayoutConstraint constraintWithItem:item.view
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollViewContent
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1.0
                                                                            constant:-itemViewTrailingMargin]];
        [self.scrollViewContent addConstraint:[NSLayoutConstraint constraintWithItem:item.view
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollViewContent
                                                                           attribute:NSLayoutAttributeLeading
                                                                          multiplier:1.0
                                                                            constant:itemViewleadingMargin]];
        [self.scrollViewContent addConstraint:[NSLayoutConstraint constraintWithItem:item.view
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:itemViewHeight]];

        if (i == 0) {
            [self.scrollViewContent addConstraint:[NSLayoutConstraint constraintWithItem:item.view
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollViewContent
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:topItemTopMargin]];
        } else {
            [self.scrollViewContent addConstraint:[NSLayoutConstraint constraintWithItem:item.view
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:lastSingleItem.view
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.0
                                                                                constant:itemViewBottomMargin]];
        }
        i++;
        lastSingleItem = item;
        [self.scanElementViews insertObject:item atIndex:[self.scanElements indexOfObject:element]];
    }
    [lastSingleItem hideBottomLine:YES];
    [self.scrollViewContent addConstraint:[NSLayoutConstraint constraintWithItem:lastSingleItem.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.scrollViewContent
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-bottomItemBottomMargin]];

    self.overlayShown = [NSLayoutConstraint constraintWithItem:self.cameraOverlayContainer
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.4
                                                      constant:0];
    self.preAnimation = [NSLayoutConstraint constraintWithItem:self.cameraOverlayContainer
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:0.5];
    self.preAnimation.priority = 600;
    if (self.scrollView.bounds.size.height > self.scanElements.count * (itemViewHeight + itemViewBottomMargin) + topItemTopMargin + bottomItemBottomMargin) {
        self.scrollView.scrollEnabled = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void)buttonScanUserDidTapItem:(PPFieldItemViewController *)itemViewController {
    PPScanElement *element = itemViewController.element;
    if (self.scanningViewController == nil) {
        self.overlay = [PPFieldOverlayViewController viewControllerFromStoryboardWithElement:element];
        [self createScanningViewController];
    }
    self.overlay.element = element;
    [self showScanningViewController];

    // Change OcrParser for newly selected element
    if (self.currentElement != nil) {
        [self.settings removeOcrParserWithName:self.currentElement.identifier];
    } else {
        self.settings = [[PPBlinkInputRecognizerSettings alloc] init];
        [self.coordinator.currentSettings.scanSettings addRecognizerSettings:self.settings];
    }
    [self.settings addOcrParser:element.factory name:element.identifier];
    [self.coordinator applySettings];

    // change  selected element view background color
    [UIView animateWithDuration:0.4f
        animations:^{
          if (self.currentElement != nil) {
              self.currentElementView.view.backgroundColor = [UIColor whiteColor];
          }
          itemViewController.view.backgroundColor = [UIColor colorWithRed:250.0f / 255 green:250.0f / 255 blue:250.0f / 255 alpha:1.0f];
        }
        completion:^(BOOL finished){
        }];
    self.currentElement = element;
    self.currentElementView = itemViewController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didFindError:(NSError *)error {
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didOutputResults:(NSArray *)results {
    for (PPRecognizerResult *result in results) {
        if ([result isKindOfClass:[PPBlinkInputRecognizerResult class]]) {
            PPBlinkInputRecognizerResult *ocrRecognizerResult = (PPBlinkInputRecognizerResult *)result;
            [self processOcrRecognizerResult:ocrRecognizerResult];
        }
    }
}

- (void)processOcrRecognizerResult:(PPBlinkInputRecognizerResult *)ocrRecognizerResult {
    NSString *result = [ocrRecognizerResult parsedResultForName:self.currentElement.identifier];
    if ([self.currentElement.factory class] == [PPIbanOcrParserFactory class]) {
        NSMutableString *separatedIban = [result mutableCopy];
        for (int i = 0; i < result.length; i += 4) {
            [separatedIban insertString:@" " atIndex:i + i / 4];
        }
        result = separatedIban;
    }
    self.currentElementView.textFieldValue.text = result;
}

- (void)createScanningViewController {
    self.scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self overlayViewController:self.overlay coordinator:self.coordinator error:nil];
    [self.scanningViewController pauseScanning];
    [self addChildViewController:self.scanningViewController];
    [self.cameraOverlayContainer addSubview:self.scanningViewController.view];
    [self.scanningViewController didMoveToParentViewController:self];
    [self.scanningViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.cameraOverlayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.scanningViewController.view
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.cameraOverlayContainer
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1.0
                                                                             constant:0]];
    [self.cameraOverlayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.scanningViewController.view
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.cameraOverlayContainer
                                                                            attribute:NSLayoutAttributeWidth
                                                                           multiplier:1.0
                                                                             constant:0]];
    [self.cameraOverlayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.scanningViewController.view
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.cameraOverlayContainer
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0
                                                                             constant:0]];
    [self.cameraOverlayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.scanningViewController.view
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.cameraOverlayContainer
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.0
                                                                             constant:0]];
}

- (void)showScanningViewController {
    if ([self.scanningViewController isScanningPaused]) {
        [self.scanningViewController resumeScanningAndResetState:YES];
    }
    for (PPFieldItemViewController *view in self.scanElementViews) {
        [view hideKeyboard];
    }

    [self.view addConstraint:self.preAnimation];
    [self.view layoutIfNeeded];
    [self.view removeConstraint:self.preAnimation];
    [self.view addConstraint:self.overlayShown];
    [UIView animateWithDuration:0.3f
        delay:0.0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
          [self.view layoutIfNeeded];
        }
        completion:^(BOOL finished){
        }];
    if (self.scrollView.bounds.size.height > self.scanElements.count * (itemViewHeight + itemViewBottomMargin) + topItemTopMargin + bottomItemBottomMargin) {
        self.scrollView.scrollEnabled = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void)hideScanningViewController {
    if (![self.scanningViewController isScanningPaused]) {
        [self.scanningViewController pauseScanning];
    }
    [self.view layoutIfNeeded];

    self.cameraOverlayContainer.backgroundColor = [UIColor blackColor];

    [self.view removeConstraint:self.overlayShown];
    [UIView animateWithDuration:0.3f
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
          [self.view layoutIfNeeded];
          self.currentElementView.view.backgroundColor = [UIColor whiteColor];
        }
        completion:^(BOOL finished) {
          [self.scanningViewController removeFromParentViewController];
          [self.scanningViewController.view removeFromSuperview];
          self.scanningViewController = nil;
        }];

    if (self.scrollView.bounds.size.height > self.scanElements.count * (itemViewHeight + itemViewBottomMargin) + topItemTopMargin + bottomItemBottomMargin) {
        self.scrollView.scrollEnabled = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.currentElementView.view.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.currentElementView.view.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self hideScanningViewController];
}

- (IBAction)didTap:(id)sender {
    [self hideScanningViewController];
}

- (IBAction)didTapFinish:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate fieldViewController:self didFinishScanningWithElements:self.scanElements];
}
@end
