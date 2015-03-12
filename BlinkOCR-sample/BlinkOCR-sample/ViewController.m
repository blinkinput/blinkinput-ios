//
//  ViewController.m
//  BlinkOCR-sample
//
//  Created by Jura on 02/03/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <BlinkOCR/BlinkOCR.h>

@interface ViewController () <PPScanDelegate>

@property (nonatomic, strong) NSString* rawOcrParserId;

@property (nonatomic, strong) NSString* priceParserId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rawOcrParserId = @"Raw ocr";
    self.priceParserId = @"Price";
}

- (IBAction)didTapScan:(id)sender {

    // Check if blink ocr is supported
    NSError *error;
    if ([PPCoordinator isPhotoPayUnsupported:&error]) {
        NSString *messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }


    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];

    // Set the license key
    settings.licenseSettings.licenseKey = @"NHF2-TG3T-OS5T-FVRY-CN6R-OTIA-FMRP-TOZL";

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPOcrRecognizerSettings *ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];

    // We want raw OCR parsing
    [ocrRecognizerSettings addOcrParser:[[PPRawOcrParserFactory alloc] init] name:self.rawOcrParserId];

    // We want to parse prices from raw OCR result as well
    [ocrRecognizerSettings addOcrParser:[[PPPriceOcrParserFactory alloc] init] name:self.priceParserId];

    // Add the recognizer setting to a list of used recognizer
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];

    // Allocate the recognition coordinator object
    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];

    // Initialize the scanning view controller
    UIViewController<PPScanningViewController>* scanningViewController = [coordinator cameraViewControllerWithDelegate:self];

    // Present it full screen. The way VC is presented defines the way it's being dismissed in scanningViewControllerDidClose:
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

#pragma mark - PPScanDelegate methods

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {

    CGFloat W = scanningViewController.view.frame.size.width;
    CGFloat H = scanningViewController.view.frame.size.height;
    CGFloat w = 300;
    CGFloat h = 70;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scanningViewController.view.frame.origin.x + W/2 - w/2, scanningViewController.view.frame.origin.y + H/2 - h/2, w, h)];
    label.text = @"Camera not authorized.\nPlease authorize it in:\nSettings->Privacy->Camera.";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;

    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

    [[scanningViewController view] addSubview:label];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
                  didFindError:(NSError *)error {
    // Can ignore. See description of the method
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {

    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
              didOutputResults:(NSArray *)results {

    // find the first recognition result and present it.
    // you can have more complex logic here, which can, for example compare fields in multiple results

    for (PPBaseResult* result in results) {
        if ([result isKindOfClass:[PPOcrScanResult class]]) {
            PPOcrScanResult* ocrResult = (PPOcrScanResult*)result;
            [self processResult:ocrResult];
            break;
        }
    };
}

- (void)processResult:(PPOcrScanResult*)ocrResult {

    NSLog(@"OCR results are:");
    NSLog(@"Raw ocr: %@", [ocrResult parsedResultForName:self.rawOcrParserId]);
    NSLog(@"Price: %@", [ocrResult parsedResultForName:self.priceParserId]);

    PPOcrResult* rawOcrObject = [ocrResult ocrResult];
    NSLog(@"Dimensions of rawOcrObject are %@", NSStringFromCGRect([rawOcrObject box]));
}

@end
