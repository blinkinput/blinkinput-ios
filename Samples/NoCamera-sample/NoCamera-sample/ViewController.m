//
//  ViewController.m
//  NoCamera-sample
//
//  Created by Jura on 28/04/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MicroBlink/MicroBlink.h>

@interface ViewController () <PPScanDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *rawOcrParserId;

@property (nonatomic, strong) NSString *priceParserId;

@property (nonatomic, strong) PPCoordinator *coordinator;

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
    settings.licenseSettings.licenseKey = @"N3OYQEGF-6RPONJ2R-F6S4RDZ5-PR6HY7D4-PR6HY7D4-PR6HY7D4-PR6HY7D4-QI6WL7LV";


    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing raw OCR scanning.
     */

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPOcrRecognizerSettings *ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];

    // We want raw OCR parsing
    [ocrRecognizerSettings addOcrParser:[self priceOcrParserFactory] name:self.priceParserId];

    // We want to parse prices from raw OCR result as well
    [ocrRecognizerSettings addOcrParser:[self rawOcrParserFactory] name:self.rawOcrParserId];

    // Add the recognizer setting to a list of used recognizer
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];


    /** 4. Initialize the Scanning Coordinator object */

    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];
    
    return coordinator;
}

- (PPPriceOcrParserFactory *)priceOcrParserFactory {
    return [[PPPriceOcrParserFactory alloc] init];
}

- (PPRawOcrParserFactory *)rawOcrParserFactory {

    // Instantiate factory
    PPRawOcrParserFactory *rawOcrFactory = [[PPRawOcrParserFactory alloc] init];

    // Don't use the algorithm for combining consecutive OCR results.
    // Using YES here makes sense only when using integrated camera management and video OCR
    rawOcrFactory.useSieve = NO;

    // Instantiate new OCR engine option
    PPOcrEngineOptions *options = [[PPOcrEngineOptions alloc] init];

    options.minimalLineHeight = 20.0f; // minimal line height shall be more than 20 pixels
    options.maximalLineHeight = 80.f; // maximal line height shall be less than 80 pixels
    options.maxCharsExpected = 1200; // there will be no more than 1200 characters on the image
    options.colorDropoutEnabled = NO; // don't use color dropot method as we assume only black/white scenes will be scanned

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
    options.charWhitelist = charWhitelist;

    // set the options
    rawOcrFactory.options = options;

    return rawOcrFactory;
}

- (IBAction)takePhoto:(id)sender {
    /** Instantiate the scanning coordinator */
    NSError *error;

    self.coordinator = [self coordinatorWithError:&error];

    /** If scanning isn't supported, present an error */
    if (self.coordinator == nil) {
        NSString *messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:messageString
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];

        return;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];

    // Use rear camera
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;

    // Displays a control that allows the user to choose only photos
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];

    // Hides the controls for moving & scaling pictures, or for trimming movies.
    cameraUI.allowsEditing = NO;

    // Shows default camera control overlay over camera preview.
    cameraUI.showsCameraControls = YES;

    // set delegate
    cameraUI.delegate = self;

    // Show view
    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    // Handle a still image capture
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];

        [self.coordinator processImage:originalImage
                        scanningRegion:CGRectMake(0.0, 0.0, 1.0, 1.0)
                              delegate:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PPScanDelegate

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController>*)scanningViewController {
    // When using direct processing, this can never happen as no camera session is started inside the SDK
}

- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
                  didFindError:(NSError*)error {
    // can be ignored
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController>*)scanningViewController {
    // When using direct processing, this can never happen as no scanning view controller is presented
}

- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
              didOutputResults:(NSArray*)results {

    // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
    // Perform your logic here

    NSString *title = @"No result";
    NSString *message = nil;

    for (PPRecognizerResult *result in results) {
        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;

            NSLog(@"OCR results are:");
            NSLog(@"Raw ocr: %@", [ocrRecognizerResult parsedResultForName:self.rawOcrParserId]);
            NSLog(@"Price: %@", [ocrRecognizerResult parsedResultForName:self.priceParserId]);

            PPOcrLayout* ocrLayout = [ocrRecognizerResult ocrLayout];
            NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect([ocrLayout box]));

            title = @"OCR result";
            message = [ocrRecognizerResult parsedResultForName:self.rawOcrParserId];
        }
    };

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];

    [alertView show];
}

@end
