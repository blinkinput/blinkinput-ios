//
//  ViewController.m
//  BlinkOCR-sample
//
//  Created by Jura on 02/03/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MicroBlink/MicroBlink.h>

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

    /** 0. Check if scanning is supported */

    NSError *error;
    if ([PPCoordinator isScanningUnsupported:&error]) {
        NSString *messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }

    NSLog(@"BlinkOCR SDK version: %@", [PPCoordinator getBuildVersionString]);


    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];


    /** 2. Setup the license key */

    // To obtain the license key, contact us at help.microblink.com with the bundle-id of your app
    settings.licenseSettings.licenseKey = @"VY5MZHBN-VD7DHWGZ-HTA5ZKSP-YXWZGFRP-AAN365JH-S6QPGN44-WQDCHOK5-S3UOFKSP";


    /** 3. Set up what is being scanned. See detailed guides for specific use cases. Here's an example for initializing raw OCR scanning. */

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPOcrRecognizerSettings *ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];

    // We want raw OCR parsing
    [ocrRecognizerSettings addOcrParser:[[PPRawOcrParserFactory alloc] init] name:self.rawOcrParserId];

    // We want to parse prices from raw OCR result as well
    [ocrRecognizerSettings addOcrParser:[[PPPriceOcrParserFactory alloc] init] name:self.priceParserId];

    // Add the recognizer setting to a list of used recognizer
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];


    /** 4. Initialize the Scanning Coordinator object */

    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];


    /** 5. Initialize the scanning view controller */
    UIViewController<PPScanningViewController>* scanningViewController = [coordinator cameraViewControllerWithDelegate:self];


    /** 6 Present it full screen. The way VC is presented defines the way it's being dismissed in scanningViewControllerDidClose: */

    // You can use other presentation methods as well
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

#pragma mark - PPScanDelegate methods

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {
    // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
                  didFindError:(NSError *)error {
    // Can be ignored. See description of the method
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {

    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
              didOutputResults:(NSArray *)results {

    // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
    // Perform your logic here

    for (PPRecognizerResult *result in results) {
        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;
            [self processOcrRecognizerResult:ocrRecognizerResult];
            break;
        }
    };
}

- (void)processOcrRecognizerResult:(PPOcrRecognizerResult*)ocrRecognizerResult {

    NSLog(@"OCR results are:");
    NSLog(@"Raw ocr: %@", [ocrRecognizerResult parsedResultForName:self.rawOcrParserId]);
    NSLog(@"Price: %@", [ocrRecognizerResult parsedResultForName:self.priceParserId]);

    PPOcrLayout* ocrLayout = [ocrRecognizerResult ocrLayout];
    NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect([ocrLayout box]));
}

@end
