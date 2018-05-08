//
//  ViewController.m
//  Starbucks-sample
//
//  Created by Jure Cular on 29/06/2017.
//  Copyright © 2017 MicroBlink. All rights reserved.
//

#import "MainViewController.h"
#import "OverlayViewController.h"
#import "ResultsViewController.h"
#import "StarbucksCardRecognizerSettings.h"

@interface MainViewController () <PPScanningDelegate, ResultsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property (strong, nonatomic) UIViewController<PPScanningViewController> *scanningViewController;

@property (strong, nonatomic) OverlayViewController *overlayViewController;

@property (strong, nonatomic) PPCameraCoordinator *coordinator;

@property (strong, nonatomic) StarbucksCardRecognizerSettings *starbucksRecognizerSettings;

@end

/* Graphical attributes */

// Scan button corner radius
static CGFloat const kScanButtonCornerRadius = 4.f;

/* String constants */

// License key, valid until 2018-02-25
static NSString *const kLicenseKey = @"JECVV5Y7-C5KXNAHO-6UM5L2VL-U25BLAPQ-ZJTWF2PD-EZTWF2PD-EZTWESKJ-ICEX2QHR";

// Starbucks card number key title
static NSString *const kStarbucksCardNumberKey = @"Starbucks card number";

// Starbucks scan button label text
static NSString *const kScanButtonLabelText = @"SCAN";

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scanButton.layer.cornerRadius = kScanButtonCornerRadius;
    self.scanButton.titleLabel.text = kScanButtonLabelText;

    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Private

- (PPCameraCoordinator *)coordinatorWithError:(NSError **)error {
    /** 0. Check if scanning is supported */

    if ([PPCameraCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:error]) {
        return nil;
    }

    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];

    settings.metadataSettings.successfulFrame = YES;

    /** 2. Setup the license key */

    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = kLicenseKey;

    PPPdf417RecognizerSettings *pdf417RecognizerSettings = [[PPPdf417RecognizerSettings alloc] init];
    [settings.scanSettings addRecognizerSettings:pdf417RecognizerSettings];

    self.starbucksRecognizerSettings = [[StarbucksCardRecognizerSettings alloc] init];
    [settings.scanSettings addRecognizerSettings:self.starbucksRecognizerSettings];

    settings.scanSettings.partialRecognitionTimeout = 4.0;

    /** 4. Initialize the Scanning Coordinator object */
    PPCameraCoordinator *coordinator = [[PPCameraCoordinator alloc] initWithSettings:settings delegate:nil];

    return coordinator;
}

- (void)createResultsViewControllerWithResultsMap:(NSDictionary *)resultsMap {
    ResultsViewController *resultsViewController = [[ResultsViewController alloc] initWithLabelsMap:resultsMap];
    resultsViewController.delegate = self;

    [self.scanningViewController addChildViewController:resultsViewController];
    [self.scanningViewController.view addSubview:resultsViewController.view];
    [resultsViewController didMoveToParentViewController:self.scanningViewController];

    [resultsViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    if (@available(iOS 11.0, *)) {
        [resultsViewController.view.safeAreaLayoutGuide.centerXAnchor constraintEqualToAnchor:self.scanningViewController.view.safeAreaLayoutGuide.centerXAnchor].active = YES;
        [resultsViewController.view.safeAreaLayoutGuide.centerYAnchor constraintEqualToAnchor:self.scanningViewController.view.safeAreaLayoutGuide.centerYAnchor].active = YES;
        [resultsViewController.view.safeAreaLayoutGuide.widthAnchor constraintEqualToAnchor:self.scanningViewController.view.safeAreaLayoutGuide.widthAnchor].active = YES;
        [resultsViewController.view.safeAreaLayoutGuide.heightAnchor constraintEqualToAnchor:self.scanningViewController.view.safeAreaLayoutGuide.heightAnchor].active = YES;
    } else {
        [resultsViewController.view.centerXAnchor constraintEqualToAnchor:self.scanningViewController.view.centerXAnchor].active = YES;
        [resultsViewController.view.centerYAnchor constraintEqualToAnchor:self.scanningViewController.view.centerYAnchor].active = YES;
        [resultsViewController.view.widthAnchor constraintEqualToAnchor:self.scanningViewController.view.widthAnchor].active = YES;
        [resultsViewController.view.heightAnchor constraintEqualToAnchor:self.scanningViewController.view.heightAnchor].active = YES;
    }

    [self.scanningViewController.view layoutIfNeeded];
}

#pragma mark - Actions

- (IBAction)didTapScanButton:(id)sender {
    /** Instantiate the scanning coordinator */
    NSError *error;

    if (!self.coordinator) {
        self.coordinator = [self coordinatorWithError:&error];
    }

    /** Create new scanning view controller */
    self.overlayViewController = [OverlayViewController viewControllerFromStoryboard];
    self.scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self
                                                                      overlayViewController:self.overlayViewController
                                                                                coordinator:self.coordinator
                                                                                      error:nil];

    /** Present the scanning view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:self.scanningViewController animated:YES completion:nil];
}

#pragma mark - PPScaningDelegate

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {
    // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didFindError:(NSError *)error {
    // Can be ignored. See description of the method
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {
    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didOutputResults:(NSArray *)results {
    [scanningViewController pauseScanning];
    [scanningViewController pauseCamera];

    NSDictionary *resultsMap;
    // Collect data from the result
    for (PPRecognizerResult *result in results) {

        if ([result isKindOfClass:[PPPdf417RecognizerResult class]]) {
            PPPdf417RecognizerResult *ocrResult = (PPPdf417RecognizerResult *)result;
            resultsMap = @{kStarbucksCardNumberKey : [ocrResult stringUsingGuessedEncoding]};
            break;
        } else if ([result isKindOfClass:[PPBlinkOcrRecognizerResult class]]) {
            PPBlinkOcrRecognizerResult *ocrResult = (PPBlinkOcrRecognizerResult *)result;
            resultsMap = [self.starbucksRecognizerSettings extractMessageFromResult:ocrResult];
            break;
        }
    }

    if (resultsMap != nil && resultsMap.count != 0) {
        [self.scanningViewController playScanSuccesSound];
        self.overlayViewController.pausedCameraImageView.hidden = NO;
        self.overlayViewController.resultShadowView.hidden = NO;
        [self createResultsViewControllerWithResultsMap:resultsMap];
    } else {
        [scanningViewController resumeCamera];
        [scanningViewController resumeScanningAndResetState:NO];
    }
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
             didOutputMetadata:(PPMetadata *)metadata {
    if ([metadata isKindOfClass:[PPImageMetadata class]]) {

        PPImageMetadata *imageMetadata = (PPImageMetadata *)metadata;
        if (imageMetadata.imageType == PPImageMetadataTypeSuccessfulFrame) {
            self.overlayViewController.pausedCameraImageView.image = imageMetadata.image;
        }
    }
}

#pragma mark - ResultsViewControllerDelegate

- (void)didTapSubmitButton:(ResultsViewController *)viewController {
    [self.scanningViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapCloseButton:(ResultsViewController *)viewController {
    self.overlayViewController.pausedCameraImageView.hidden = YES;
    self.overlayViewController.resultShadowView.hidden = YES;

    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];

    [self.scanningViewController resumeCamera];
    [self.scanningViewController resumeScanningAndResetState:YES];
}

@end
