//
//  ViewController.m
//  Templating-Sample
//
//  Created by Dino on 08/06/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "ViewController.h"
#import <MicroBlink/MicroBlink.h>

@interface ViewController () <PPScanningDelegate, PPDocumentClassifier>

@end

@implementation ViewController

static NSString *US_CHEQUE_OCR_LINE = @"ocrLine";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (PPCameraCoordinator *)coordinatorWithError:(NSError**)error {
    
    /** 0. Check if scanning is supported */
    
    if ([PPCameraCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:error]) {
        return nil;
    }
    
    
    /** 1. Initialize the Scanning settings */
    
    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];
    
    // tell which metadata you want to receive. Metadata collection takes CPU time - so use it only if necessary!
    settings.metadataSettings.dewarpedImage = YES; // get dewarped image of ID documents
    settings.metadataSettings.debugMetadata.debugOcrInputFrame = YES;
    
    
    /** 2. Setup the license key */
    
    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"G4RQQQFB-2CW2RQWZ-TAYZQMLH-NW5AVO3P-WI2SNHPV-HSSUH2FY-PYPHCENS-ZKMNOIVO"; // Valid temporarily
    


    
    /**********************************************************************************************************************/
    /**************  For Croatian ID sample images please check Croatian_ID_Images.xcassets in this project  **************/
    /**********************************************************************************************************************/
    
    
    
    
    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Remove undesired recognizers (added below) for optimal performance.
     */
    {
        PPBlinkOcrRecognizerSettings *ocrSettings = [[PPBlinkOcrRecognizerSettings alloc] init];
        
        NSMutableArray<PPDecodingInfo*> *decodingInfosArray = [NSMutableArray array];
        
        /** Setup reading of suspected OCR line with all awailable fonts */
        {
            /** Pixel height of returned image */
            int dewarpHeight = 150;
            
            /**
             * For extracting first and last names, we will use regex parser with regular expression which
             * attempts to extract as many uppercase words as possible from single line.
             */
            PPRegexOcrParserFactory *ocrLineParser = [[PPRegexOcrParserFactory alloc] initWithRegex:@"[A-Za-z0-9+-<> ]{10,40}"];
            
            /**
             * tweak OCR engine options - allow only recognition of uppercase letters used in Croatia
             */
            PPOcrEngineOptions* ocrEngineoptions = [[PPOcrEngineOptions alloc] init];
//            ocrEngineoptions.minimalLineHeight = 10;
//            ocrEngineoptions.minimalLineHeight = 140;
            ocrEngineoptions.imageProcessingEnabled = true;
            ocrEngineoptions.charWhitelist = [self commonWhitelist];
            [ocrLineParser setOptions:ocrEngineoptions];

            /**
             * Add parser to recognizer settings
             */
            [ocrSettings addOcrParser:ocrLineParser name:US_CHEQUE_OCR_LINE group:US_CHEQUE_OCR_LINE];

            /** 
             * Locations of first name string on borth old and new ID cards
             */
            CGRect ocrLineLocation = CGRectMake(0.0, 0.85, 1.0, 0.1);
            
            /**
             * Add locations to list
             * Since we want to use selected parsers on these locations, uniqueId of decoding infos must be the same as parser group id.
             */
            [decodingInfosArray addObject:[[PPDecodingInfo alloc] initWithLocation:ocrLineLocation dewarpedHeight:dewarpHeight uniqueId:US_CHEQUE_OCR_LINE]];
        }
        
        
        /**
         * Create ID card document specification. Document specification defines geometric/scanning properties of documents to be detected
         */
        PPDocumentSpecification *usChequeDocumentSpecification = [PPDocumentSpecification newFromPreset:PPDocumentPresetCheque];
        
        /**
         * Set decoding infos as our classification decoding infos. One has location of document number on old id, other on new Id
         */
        [usChequeDocumentSpecification setDecodingInfo:decodingInfosArray];
        
        /**
         * Wrap Document specification in detector settings
         */
        PPDocumentDetectorSettings *detectorSettings = [[PPDocumentDetectorSettings alloc] initWithNumStableDetectionsThreshold:1];
        [detectorSettings setDocumentSpecifications:@[usChequeDocumentSpecification]];
        
        /**
         * Add created detector settings to recognizer
         */
        [ocrSettings setDetectorSettings:detectorSettings];

        
        [settings.scanSettings addRecognizerSettings:ocrSettings];
    }
    
    
    /** 4. Initialize the Scanning Coordinator object */
    
    PPCameraCoordinator *coordinator = [[PPCameraCoordinator alloc] initWithSettings:settings delegate:nil];
    
    return coordinator;
}

- (NSMutableSet *)commonWhitelist {
    
    // initialize new char whitelist
    NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];
    
    // Add chars '0'-'9'
    for (int c = '0'; c <= '9'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_ANY]];
    }
    for (int c = 'A'; c <= 'Z'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_ANY]];
    }
    for (int c = 'a'; c <= 'z'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_ANY]];
    }
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'+' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'-' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'<' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'>' font:PP_OCR_FONT_ANY]];
    
    return charWhitelist;
}

- (NSMutableSet *)micrCharsWhitelist {
    
    // initialize new char whitelist
    NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];
    
    // Add chars '0'-'9'
    for (int c = '0'; c <= '9'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_MICR]];
    }
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'+' font:PP_OCR_FONT_MICR]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'-' font:PP_OCR_FONT_MICR]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'<' font:PP_OCR_FONT_MICR]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'>' font:PP_OCR_FONT_MICR]];
    
    return charWhitelist;
}

- (IBAction)didTapScan:(id)sender {
    
    /** Instantiate the scanning coordinator */
    NSError *error;
    PPCameraCoordinator *coordinator = [self coordinatorWithError:&error];
    
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
    UIViewController<PPScanningViewController>* scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self coordinator:coordinator error:nil];
    
    // allow rotation if VC is displayed as a modal view controller
    scanningViewController.autorotate = YES;
    scanningViewController.supportedOrientations = UIInterfaceOrientationMaskAll;
    
    /** Present the scanning view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

#pragma mark - PPScaningDelegate

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
     * Usually there will be only one result. Multiple results are possible when there are 2 or more detected objects on a single image (i.e. pdf417 and QR code side by side)
     */
    
    // first, pause scanning until we process all the results
    [scanningViewController pauseScanning];
    
    NSString* message;
    NSString* title;
    
    // Collect data from the result
    for (PPRecognizerResult* result in results) {
        
        if ([result isKindOfClass:[PPBlinkOcrRecognizerResult class]]) {
            /** Specified document was detected */
            PPBlinkOcrRecognizerResult* blinkOcrResult = (PPBlinkOcrRecognizerResult*)result;
            PPOcrLayout* ocrResult = [blinkOcrResult ocrLayoutForParserGroup:US_CHEQUE_OCR_LINE];
            
            NSInteger numCharacters = 0;
            NSInteger numMicrCharacters = 0;
            NSInteger sumMicrCharactersQuality = 0;
            NSInteger sumHeights = 0;
            
            for (PPOcrBlock* block in [ocrResult blocks]) {
                for (PPOcrLine* line in [block lines]){
                    for (PPOcrChar* character in [line chars]){
                        if ([character value] == ' ') continue;
                        
                        numCharacters ++;
                        sumHeights += [character height];
                        if ([character font] == PP_OCR_FONT_MICR) {
                            numMicrCharacters ++;
                            sumMicrCharactersQuality += [character quality];
                        }
                    }
                }
            }
            
            bool thrueCheque = true;
            
//            NSString* heightString = [NSString stringWithFormat:@"%d", (int) ((float )sumHeights / (float) numCharacters)];
            NSString* heightString = [NSString stringWithFormat:@"%d", (int) ((float) sumHeights / (float) numCharacters)];
            
            if (thrueCheque){
                title = @"US Cheque";
                message = [blinkOcrResult parsedResultForName:US_CHEQUE_OCR_LINE parserGroup:US_CHEQUE_OCR_LINE];
                message = [message stringByAppendingString:@"\nNumCharacters: "];
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%d", numCharacters]];
                message = [message stringByAppendingString:@"\nNumMICR: "];
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%d", numMicrCharacters]];
                message = [message stringByAppendingString:@" avgHeight: "];
                message = [message stringByAppendingString:heightString];
            }else{
                title = @"Not US Cheque";
                message = @"";
            }
        }
    };
    
    // present the alert view with scanned results
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanninvViewController didFinishDetectionWithResult:(PPDetectorResult *)result {

}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didOutputMetadata:(PPMetadata *)metadata {
    
    // Check if metadata obtained is image. You can set what type of image is outputed by setting different properties of PPMetadataSettings (currently, dewarpedImage is set at line 57)
    if ([metadata isKindOfClass:[PPImageMetadata class]]) {
        
        PPImageMetadata *imageMetadata = (PPImageMetadata *)metadata;
        UIImage *img = imageMetadata.image;
        
        if ([imageMetadata.name isEqualToString:@"EUDL"]) {
            UIImage *eudlImage = [imageMetadata image];
            NSLog(@"We have dewarped and trimmed image of the EUDL, with size (%@, %@)", @(eudlImage.size.width), @(eudlImage.size.height));
        } else if ([imageMetadata.name isEqualToString:@"MRTD"]) {
            UIImage *mrtdImage = [imageMetadata image];
            NSLog(@"We have dewarped and trimmed image of the Machine readable travel document, with size (%@, %@)", @(mrtdImage.size.width), @(mrtdImage.size.height));
        } else if ([imageMetadata.name isEqualToString:@"MyKad"]) {
            UIImage *myKadImage = [imageMetadata image];
            NSLog(@"We have dewarped and trimmed image of the MyKad, with size (%@, %@)", @(myKadImage.size.width), @(myKadImage.size.height));
        } else {
            UIImage *image = [imageMetadata image];
            NSLog(@"We have image %@ with size (%@, %@)", metadata.name, @(image.size.width), @(image.size.height));
        }
    }
}

// dismiss the scanning view controller when user presses OK.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PPDocumentClassifier

- (NSString *)classifyDocumentFromResult:(PPTemplatingRecognizerResult *)result {
    /**
     * Document is detected but it doesnt contain document numbers on their expected locations
     */
    return @"";
}

@end
