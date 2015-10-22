//
//  ViewController.m
//  Receipt-sample
//
//  Created by Jura on 21/10/15.
//  Copyright © 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MicroBlink/MicroBlink.h>

@interface ViewController () <PPScanDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PPRawOcrParserFactory *)rawParserForReceipts {
    PPRawOcrParserFactory* rawParserFactory = [[PPRawOcrParserFactory alloc] init];

    rawParserFactory.options.minimalLineHeight = 10;
    rawParserFactory.options.maximalLineHeight = 50;
    rawParserFactory.options.maxCharsExpected = 3000;
    rawParserFactory.options.colorDropoutEnabled = NO;

    // initialize new char whitelist
    NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];

    // Add chars 'a'-'z'
    for (int c = 'a'; c <= 'z'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_ANY]];
    }

    // Add chars 'A'-'Z'
    for (int c = 'A'; c <= 'Z'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_ANY]];
    }

    // Add chars '0'-'9'
    for (int c = '0'; c <= '9'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_ANY]];
    }

    // Add chars ".-$%"
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'.' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'-' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'$' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'%' font:PP_OCR_FONT_ANY]];

    // set the whitelist
    rawParserFactory.options.charWhitelist = charWhitelist;

    return rawParserFactory;
}

/**
 * Method allocates and initializes the Scanning coordinator object.
 * Coordinator is initialized with settings for scanning
 *
 *  @param error Error object, if scanning isn't supported
 *
 *  @return initialized coordinator
 */
- (PPCoordinator *)coordinatorWithError:(NSError**)error {

    /** 0. Check if scanning is supported */

    if ([PPCoordinator isScanningUnsupported:error]) {
        return nil;
    }


    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];


    /** 2. Setup the license key */

    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"4MQXEMJK-5DEI422A-UNZLLO4M-ZZDAG3O4-NZM3CPLN-3RXFTMJ5-NXOG4WNR-GVYY77XS";

    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing raw OCR scanning.
     */

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPOcrRecognizerSettings *ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];

    // We want raw OCR parsing
    [ocrRecognizerSettings addOcrParser:[self rawParserForReceipts] name:@"Raw"];

    // Add the recognizer setting to a list of used recognizer
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];


    /** 4. Initialize the Scanning Coordinator object */

    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];
    
    return coordinator;
}

- (void)showCoordinatorError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                             message:[error localizedDescription]
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];

    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)didTapScan:(id)sender {

    /** Instantiate the scanning coordinator */
    NSError *error;
    PPCoordinator *coordinator = [self coordinatorWithError:&error];

    /** If scanning isn't supported, show an error */
    if (coordinator == nil) {
        [self showCoordinatorError:error];
        return;
    }

    /** Allocate and present the scanning view controller */
    UIViewController<PPScanningViewController>* scanningViewController = [coordinator cameraViewControllerWithDelegate:self];

    /** You can use other presentation methods as well */
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

#pragma mark - PPScanDelegate

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

    // first, pause scanning until we process all the results
    [scanningViewController pauseScanning];

    // Collect data from the result
    for (PPRecognizerResult* result in results) {

        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;

            NSLog(@"OCR results are:");
            NSLog(@"Raw ocr: %@", [ocrRecognizerResult parsedResultForName:@"Raw"]);
        }
    };

    // resume scanning while preserving internal recognizer state
    [scanningViewController resumeScanningAndResetState:NO];
}

@end
