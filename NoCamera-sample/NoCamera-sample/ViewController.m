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

@property (nonatomic, strong) PPCoordinator *coordinator;

@property (nonatomic, strong) NSString* rawOcrParserId;

@property (nonatomic, strong) NSString* priceParserId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.rawOcrParserId = @"Raw ocr";
    self.priceParserId = @"Price";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    options.maxCharsExpected = 600; // there will be no more than 600 characters on the image
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
    NSLog(@"Take photo!");

    // Check if scanning is supported
    NSError *error;
    if ([PPCoordinator isScanningUnsupported:&error]) {
        NSString *messageString = [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];


    /** 2. Setup the license key */
    settings.licenseSettings.licenseKey = @"ASU26BCE-6SSE44DL-LAAOVEIR-Q6GWUWQT-3YIYPDLK-LIJ54EMH-RVVFUE66-2FKOST3H";


    /** 3. Set up what is being scanned. See detailed guides for specific use cases. Here's an example for initializing raw and price OCR scanning. */

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPOcrRecognizerSettings *ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];

    /** 3.a - We want to parse prices from raw OCR result as well */
    [ocrRecognizerSettings addOcrParser:[self priceOcrParserFactory] name:self.priceParserId];

    /** 3.b - We want raw OCR parsing, but with custom OCR settings */
    [ocrRecognizerSettings addOcrParser:[self rawOcrParserFactory] name:self.rawOcrParserId];

    /** 3.c Add the recognizer setting to a list of used recognizer */
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];

    // get coordinator
    self.coordinator = [[PPCoordinator alloc] initWithSettings:settings];

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];

    // Use rear camera
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;

    // Displays a control that allows the user to choose only photos
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];

    // Hides the controls for moving & scaling pictures, or for trimming movies.
    cameraUI.allowsEditing = NO;

    // Shows default camera control overlay over camera preview.
    // TODO: set this to NO and provide custom overlay
    cameraUI.showsCameraControls = YES;

    // set delegate
    cameraUI.delegate = self;

    [self.coordinator initializeRecognizers];

    // Show view
    // in iOS7 (as of DP6) this shows a bugged status bar (see https://devforums.apple.com/message/861462#861462)
    // TODO: iOS 6 should be tested
    // iOS5 works OK, just like Facebook app
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

    for (PPRecognizerResult *result in results) {
        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;

            NSLog(@"OCR results are:");
            NSLog(@"Raw ocr: %@", [ocrRecognizerResult parsedResultForName:self.rawOcrParserId]);
            NSLog(@"Price: %@", [ocrRecognizerResult parsedResultForName:self.priceParserId]);

            PPOcrLayout* ocrLayout = [ocrRecognizerResult ocrLayout];
            NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect([ocrLayout box]));

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"OCR result"
                                                                message:[ocrRecognizerResult parsedResultForName:self.rawOcrParserId]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];

            [alertView show];
        }
    };
}

@end
