//
//  ViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 02/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPFieldViewController.h"
#import "PPFormOcrOverlayViewController.h"
#import "PPResultViewController.h"
#import "PPScanElement.h"
#import "ViewController.h"
#import <MicroBlink/MicroBlink.h>
#import <MicroBlink/PPBlinkOcrRecognizerResult.h>
#import "PPParsers.h"
#import "PPSelectedParsersViewController.h"

@interface ViewController () <PPFormOcrOverlayViewControllerDelegate, PPResultViewControllerDelegate, PPFieldViewControllerDelegate>

@property(nonatomic) NSMutableArray *scanElements;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanElements = [[PPParsers getInitialParsers] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.buttonSettings.hidden = ![PPParsers areSettingsAllowed];
}

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didFindError:(NSError *)error {
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didOutputResults:(NSArray *)results {
}

- (IBAction)didTapScanForm:(id)sender {
    PPCameraCoordinator *coordinator = [self createCordinator];
    [self presentFormScannerWithCoordinator:coordinator];
}
- (IBAction)didTapScanFields:(id)sender {
    PPCameraCoordinator *coordinator = [self createCordinator];
    if (self.scanElements.count > 0) {
        PPFieldViewController *controller = [PPFieldViewController viewControllerFromStoryboard];
        controller.delegate = self;
        controller.coordinator = coordinator;
        controller.scanElements = self.scanElements;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"No Scan Elements Present"
                                                           message:@"Tap Settings to add Scan Elements"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

- (PPCameraCoordinator *)createCordinator {
    NSError *error;
    if ([PPCameraCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:&error]) {
        NSString *messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return nil;
    }
    PPSettings *settings = [[PPSettings alloc] init];
    settings.licenseSettings.licenseKey = @LICENSE_KEY;
    PPCameraCoordinator *coordinator = [[PPCameraCoordinator alloc] initWithSettings:settings];
    return coordinator;
}

- (void)formOcrOverlayViewControllerWillClose:(PPFormOcrOverlayViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)formOcrOverlayViewController:(PPFormOcrOverlayViewController *)vc didFinishScanningWithElements:(NSArray *)scanElements {
    [self dismissViewControllerAnimated:YES
                             completion:^(void) {
                               [self showResultWithScanElements:scanElements];
                             }];
}

- (void)presentFormScannerWithCoordinator:(PPCameraCoordinator *)coordinator {
    if (coordinator == nil)
        return;
    if (self.scanElements.count > 0) {
        PPFormOcrOverlayViewController *overlayViewController = [PPFormOcrOverlayViewController allocFromNibName:@"PPFormOcrOverlayViewController"];

        overlayViewController.scanElements = self.scanElements;
        overlayViewController.coordinator = coordinator;
        overlayViewController.delegate = self;

        UIViewController<PPScanningViewController> *scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:nil overlayViewController:overlayViewController coordinator:coordinator error:nil];

        [self presentViewController:scanningViewController animated:YES completion:nil];
    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"No Scan Elements Present"
                                                           message:@"Tap Settings to add Scan Elements"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

- (void)buttonCloseDidTap:(PPResultViewController *)viewController {
    [UIView animateWithDuration:0.3
        delay:0.0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
          viewController.view.alpha = 0.0f;
        }
        completion:^(BOOL finished) {
          [viewController.view removeFromSuperview];
          [viewController removeFromParentViewController];
        }];
}

- (void)buttonRightDidTap:(PPResultViewController *)viewController {
}

- (void)fieldViewControllerWillClose:(PPFieldViewController *)vc {
}

- (void)fieldViewController:(PPFieldViewController *)vc didFinishScanningWithElements:(NSArray *)scanElements {
    [self showResultWithScanElements:scanElements];
}

- (void)showResultWithScanElements:(NSArray *)scanElements {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (PPScanElement *element in scanElements) {
        [dict setValue:element.value forKey:element.localizedTitle];
    }

    PPResultViewController *resultView = [[PPResultViewController alloc] initWithTitle:@"Scan Results" labels:dict subTitle:@"" labelOrder:nil];
    resultView.delegate = self;
    resultView.view.alpha = 0.0f;
    [resultView.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addChildViewController:resultView];
    [self.view addSubview:resultView.view];
    [resultView didMoveToParentViewController:self];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.8
                                                           constant:0.0]];

    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       resultView.view.alpha = 0.95f;
                     }
                     completion:nil];
}
- (IBAction)buttonSettingsDidTap:(id)sender {
    PPSelectedParsersViewController *someViewController = [PPSelectedParsersViewController viewControllerFromStoryboard];
    someViewController.scanElements = self.scanElements;

    [self.navigationController pushViewController:someViewController animated:YES];
}

@end
