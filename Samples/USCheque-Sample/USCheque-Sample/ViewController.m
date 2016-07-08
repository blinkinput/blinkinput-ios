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

@property (nonatomic, strong) PPImageMetadata *imageMetadata;

@end

@implementation ViewController

static NSString *US_CHEQUE_CLASSIFICATION = @"classification";
static NSString *US_CHEQUE_OCR_LINE = @"ocrLine";
static NSString *CLASS_US_CHEQUE = @"classUSCheque";
static NSString *FULL_DOCUMENT_IMAGE = @"fullDocumentImage";


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
    
    /*--------------------------------------*/
    /*  0. Check if scanning is supported   */
    /*--------------------------------------*/
    
    if ([PPCameraCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:error]) {
        return nil;
    }
    
    /*---------------------------------------*/
    /*  1. Initialize the Scanning settings  */
    /*---------------------------------------*/
    
    // This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];
    
    // tell which metadata you want to receive. Metadata collection takes CPU time - so use it only if necessary!
    settings.metadataSettings.dewarpedImage = YES; // get dewarped image of documents
    
    /*----------------------------*/
    /*  2. Setup the license key  */
    /*----------------------------*/
    
    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"WYJEKDWZ-MSZCFGY2-5KDVCIU3-5J4KUJHF-H64RWKKL-K2GYGCEQ-L77DAWSW-OJI4JOQI"; // Valid temporarily
    

 
    
    /**********************************************************************************************************************/
    /**************  For Croatian ID sample images please check Cheque_sample.xcassets in this project  **************/
    /**********************************************************************************************************************/
    
    
    
    
    /*------------------------------------*/
    /*  3. Set up what is being scanned.  */
    /*------------------------------------*/
    {
        PPBlinkOcrRecognizerSettings *ocrSettings = [[PPBlinkOcrRecognizerSettings alloc] init];
        
        NSMutableArray<PPDecodingInfo*> *classificationInfosArray = [NSMutableArray array];
        NSMutableArray<PPDecodingInfo*> *ocrLineInfosArray = [NSMutableArray array];
        
        /**
         * Locations of OCR line is at the bottom of the document
         */
        CGRect ocrLineLocation = CGRectMake(0.0, 0.82, 1.0, 0.16);
        
        /**
         * Pixel height of image for reading OCR line
         */
        int dewarpHeight = 200;
        
        /** Setup reading of suspected OCR line with all awailable fonts */
        {
            /**
             * For detecting of detected document has something that looks like OCR line we use Regex parser
             * which only checks if suspected OCR line has something what we expect
             */
            PPRegexOcrParserFactory *classificationParser = [[PPRegexOcrParserFactory alloc] initWithRegex:@"([+-<>]?\\d{2,}[+-<>]? ?){3,10}"];
            
            /**
             * Tweak OCR engine options - allow all fonts
             */
            PPOcrEngineOptions* classificationOcrEngineOptions = [[PPOcrEngineOptions alloc] init];
            classificationOcrEngineOptions.minimalLineHeight = 25;
            classificationOcrEngineOptions.charWhitelist = [self commonWhitelist];
            [classificationParser setOptions:classificationOcrEngineOptions];

            /**
             * Add parser to recognizer settings
             */
            [ocrSettings addOcrParser:classificationParser name:US_CHEQUE_CLASSIFICATION group:US_CHEQUE_CLASSIFICATION];
            
            /**
             * Add locations to classification list. To perform parsing with classificationParser on desired location,
             * uniqueId of decoding infos must be the same as parser groupId.
             */
            [classificationInfosArray addObject:[[PPDecodingInfo alloc] initWithLocation:ocrLineLocation dewarpedHeight:dewarpHeight uniqueId:US_CHEQUE_CLASSIFICATION]];
        }
        
        /** Setup reading of confirmed OCR line with MICR font only */
        {
            /**
             * For reading of micr OCR line use Regex parser with regex which corresponds with actual OCR line
             */
            NSString *chequeRegexOne = @"<\\d+< ?(\\+?\\d+-)?\\d+\\+ ?(\\d+-?)+<( ?\\d+)?";
            NSString *chequeRegexTwo = @"\\+\\d+\\+ ?<?(\\d{2,} ?)+< ?\\d{2,}";
            PPRegexOcrParserFactory *ocrLineParser = [[PPRegexOcrParserFactory alloc] initWithRegex:[NSString stringWithFormat:@"(%@)|(%@)", chequeRegexOne, chequeRegexTwo]];
            
            /**
             * Tweak OCR engine options - use onlly MICR font
             */
            PPOcrEngineOptions* ocrEngineOptions = [[PPOcrEngineOptions alloc] init];
            ocrEngineOptions.minimalLineHeight = 25;
            ocrEngineOptions.charWhitelist = [self micrWhitelist];
            [ocrLineParser setOptions:ocrEngineOptions];
            
            /**
             * Add parser to recognizer settings
             */
            [ocrSettings addOcrParser:ocrLineParser name:US_CHEQUE_OCR_LINE group:US_CHEQUE_OCR_LINE];
            
            /**
             * Add location to ocrLine list. To perform parsing with ocrLineParser on desired location,
             * uniqueID of decoding infos must be the same as parser groupId.
             */
            [ocrLineInfosArray addObject:[[PPDecodingInfo alloc] initWithLocation:ocrLineLocation dewarpedHeight:dewarpHeight uniqueId:US_CHEQUE_OCR_LINE]];
        }
        
        /** Setup image to be displayed */
        {
            /*
             * Display full image
             */
            CGRect ocrLineLocation = CGRectMake(0.0, 0.0, 1.0, 1.0);
            
            /**
             * Pixel height of returned full document image
             */
            int fullDocumentDewarpHeight = 500;
            
            [ocrLineInfosArray addObject:[[PPDecodingInfo alloc] initWithLocation:ocrLineLocation dewarpedHeight:fullDocumentDewarpHeight uniqueId:FULL_DOCUMENT_IMAGE]];
        }
        
        /**
         * Create ID card document specification. Document specification defines geometric/scanning properties of documents to be detected
         */
        PPDocumentSpecification *usChequeDocumentSpecification = [PPDocumentSpecification newFromPreset:PPDocumentPresetCheque];
        
        /**
         * Set decoding infos as our classification decoding infos. One has location of document number on old id, other on new Id
         */
        [usChequeDocumentSpecification setDecodingInfo:classificationInfosArray];
        
        /**
         * Wrap Document specification in detector settings
         */
        PPDocumentDetectorSettings *detectorSettings = [[PPDocumentDetectorSettings alloc] initWithNumStableDetectionsThreshold:1];
        [detectorSettings setDocumentSpecifications:@[usChequeDocumentSpecification]];
        
        /**
         * Add created detector settings to recognizer
         */
        [ocrSettings setDetectorSettings:detectorSettings];
        
        /**
         * Set this class as document classifier delegate
         */
        [ocrSettings setDocumentClassifier:self];
        
        /**
         * Add decoding infos for classified results. These infos and their parsers will only be processed if classifier outputs the selected class
         */
        [ocrSettings setDecodingInfoSet:ocrLineInfosArray forClassifierResult:CLASS_US_CHEQUE];
        
        [settings.scanSettings addRecognizerSettings:ocrSettings];
    }
    
    
    /*-------------------------------------------------*/
    /*  4. Initialize the Scanning Coordinator object  */
    /*-------------------------------------------------*/
    
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
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'+' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'-' font:PP_OCR_FONT_ANY]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'<' font:PP_OCR_FONT_ANY]];
    
    return charWhitelist;
}

- (NSMutableSet *)micrWhitelist {
    
    // initialize new char whitelist
    NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];
    
    // Add chars '0'-'9'
    for (int c = '0'; c <= '9'; c++) {
        [charWhitelist addObject:[PPOcrCharKey keyWithCode:c font:PP_OCR_FONT_MICR]];
    }
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'+' font:PP_OCR_FONT_MICR]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'-' font:PP_OCR_FONT_MICR]];
    [charWhitelist addObject:[PPOcrCharKey keyWithCode:'<' font:PP_OCR_FONT_MICR]];
    
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
            
            title = @"US Cheque";
            message = [blinkOcrResult parsedResultForName:US_CHEQUE_OCR_LINE parserGroup:US_CHEQUE_OCR_LINE];
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
        
        if ([imageMetadata.name isEqualToString:FULL_DOCUMENT_IMAGE]) {
            self.imageMetadata = (PPImageMetadata *)metadata;
            NSLog(@"We have dewarped and cropped image of the US cheque");
        }
    }
}

// dismiss the scanning view controller when user presses OK.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PPDocumentClassifier

- (NSString *)classifyDocumentFromResult:(PPTemplatingRecognizerResult *)result {
    
    PPBlinkOcrRecognizerResult* blinkOcrResult = (PPBlinkOcrRecognizerResult*)result;

    /**
     * If we did'n find anything structured on specified position this is definitely not US cheque
     */
    if ([[blinkOcrResult parsedResultForName:US_CHEQUE_CLASSIFICATION parserGroup:US_CHEQUE_CLASSIFICATION] length] == 0){
        return @"";
    }
    
    /**
     *  Analyze full OCR result to determine if scanned region is indeed OCR line from US cheque
     */
    PPOcrLayout* ocrResult = [blinkOcrResult ocrLayoutForParserGroup:US_CHEQUE_CLASSIFICATION];

    NSInteger numMicrCharacters = 0;
    NSInteger numRelevantCharacters = 0;
    NSCharacterSet *isSpaceChar = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    for (PPOcrBlock* block in [ocrResult blocks]) {
        for (PPOcrLine* line in [block lines]){
            for (PPOcrChar* character in [line chars]){
                
                if ([isSpaceChar characterIsMember:[character value]] || [character value] == '0'
                        || [character value] == 'O' || [character value] == 'o') {
                    continue;
                }
                
                numRelevantCharacters ++;
                
                if ([character font] == PP_OCR_FONT_MICR) {
                    numMicrCharacters ++;
                }
                
            }
        }
    }
    
    /**
     * US cheques should have at least 30% characters that are in MICR font
     */
    if (numMicrCharacters > (int) ((float) numRelevantCharacters * 0.3)){
        return CLASS_US_CHEQUE;
    }
    
    /**
     * Document is detected but it doesnt contain MICR on expected location
     */
    return @"";
}

@end
