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

/**
 * Method allocates and initializes the Scanning coordinator object.
 * Coordinator is initialized with settings for scanning
 * Modify this method to include only those recognizer settings you need. This will give you optimal performance
 *
 *  @param error Error object, if scanning isn't supported
 *
 *  @return initialized coordinator
 */
- (PPCoordinator *)coordinatorWithError:(NSError**)error {

    /** 0. Check if scanning is supported */

    if ([PPCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:error]) {
        return nil;
    }


    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];


    /** 2. Setup the license key */

    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"WEFJLHGH-N3XXMX5P-D27T2R7H-LQRMXLLX-5NXQEQ5I-763Q2DXQ-ZYDVQKYW-E7VXMPWA";
    


    /** 
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing raw OCR scanning. 
     */
    

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPBlinkOcrRecognizerSettings *ocrRecognizerSettings = [[PPBlinkOcrRecognizerSettings alloc] init];

    
    PPRawOcrParserFactory *rawParserFactory = [[PPRawOcrParserFactory alloc] init];
     // Denotes if this parser is required to output results.
    rawParserFactory.isRequired = NO;
    
    // We want extract raw OCR, this outputs all recognized characters on an image
    [ocrRecognizerSettings addOcrParser:rawParserFactory name:self.rawOcrParserId];
    
    PPPriceOcrParserFactory *priceParserFactory = [[PPPriceOcrParserFactory alloc] init];
    // Denotes if this parser is required to output results.
    priceParserFactory.isRequired = NO;
    
    // We want to extract price, this outputs all recognized prices/amounts on an image
    [ocrRecognizerSettings addOcrParser:priceParserFactory name:self.priceParserId];
    
    // Add the recognizer setting to a list of used recognizers
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];


    /** 4. Initialize the Scanning Coordinator object */

    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];

    return coordinator;
}

- (IBAction)didTapScan:(id)sender {

    /** Instantiate the scanning coordinator */
    NSError *error;
    PPCoordinator *coordinator = [self coordinatorWithError:&error];

    /** If scanning isn't supported, present an error */
    if (coordinator == nil) {
        NSString *messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:messageString
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];

        return;
    }

    /** Create new scanning view controller */
    UIViewController<PPScanningViewController>* scanningViewController = [coordinator cameraViewControllerWithDelegate:self];
    
    /** Present the scanning view controller. You can use other presentation methods as well (instead of presentViewController) */
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
    
    /**
     * Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
     * Each member of results array will represent one result for a single processed image
     * Usually (and in this sample app) there will be only one result. Multiple results are possible when there are 2 or more detected objects on a single image (i.e. detected OCR
     * result and pdf417 code in case both recognizers are used)
     */
    
    // first, pause scanning until we process all the results
    [scanningViewController pauseScanning];
    
    // Collect data from the result
    for (PPRecognizerResult* result in results) {
        
        if ([result isKindOfClass:[PPBlinkOcrRecognizerResult class]]) {
            /** Characters were detected */
            PPBlinkOcrRecognizerResult* ocrRecognizerResult = (PPBlinkOcrRecognizerResult*)result;
            
            NSLog(@"OCR results are:");
            
            /** We fetch OCR results from different parsers by parser names (which we used when we were creating parsers) */
            NSLog(@"Raw ocr: %@", [ocrRecognizerResult parsedResultForName:self.rawOcrParserId]);
            NSLog(@"Price: %@", [ocrRecognizerResult parsedResultForName:self.priceParserId]);
            
            // Positions of detected characters
            PPOcrLayout* ocrLayout = [ocrRecognizerResult ocrLayout];
            NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect([ocrLayout box]));
        }
    };
    
    // resume scanning while preserving internal recognizer state
    [scanningViewController resumeScanningAndResetState:NO];
}

// dismiss the scanning view controller when user presses OK.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
