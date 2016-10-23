//
//  ViewController.m
//  Templating-Sample
//
//  Created by Dino on 08/06/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "ViewController.h"
#import "PPCustomOverlay.h"
#import "PPResultViewController.h"
#import <MicroBlink/MicroBlink.h>

@interface ViewController () <PPScanningDelegate, PPDocumentClassifier, PPResultViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) PPImageMetadata *imageMetadata;
@property (nonatomic) PPCustomOverlay *overlay;
@property (nonatomic) UIViewController<PPScanningViewController> *scanningViewController;
@property(nonatomic) UIImageView *succesfulImage;
@property(nonatomic) UIView *blurView;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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

    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];

    if ([appID isEqualToString:@"com.microblink.USCheque-Sample"]) {
        // Visit www.microblink.com to get the license key for your app
        settings.licenseSettings.licenseKey = @"74XUZZMF-LVYKALAT-DLVIOUO2-RPMKOV5O-TPVHRKRE-4U73SGZJ-JNLI266C-23MX5UZC"; // Valid temporarily
    } else if ([appID isEqualToString:@"com.microblink.photopay.checkscan"]) {
        // Visit www.microblink.com to get the license key for your app
        settings.licenseSettings.licenseKey = @"WSKYLZR7-EY6SMOJQ-ZYJABDOY-GERETDFF-4OESXE3X-S2VPP725-QHEA2473-HKKO2ZNN"; // Valid temporarily
    }
    
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
    self.overlay = [[PPCustomOverlay alloc] init];
    UIViewController<PPScanningViewController>* scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self overlayViewController:self.overlay coordinator:coordinator error:nil];
    
    // allow rotation if VC is displayed as a modal view controller
    scanningViewController.autorotate = YES;
    scanningViewController.supportedOrientations = UIInterfaceOrientationMaskLandscape;
    self.scanningViewController = scanningViewController;
    
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
    
    // Collect data from the result
    for (PPRecognizerResult* result in results) {
        
        if ([result isKindOfClass:[PPBlinkOcrRecognizerResult class]]) {
            /** Specified document was detected */
            PPBlinkOcrRecognizerResult* blinkOcrResult = (PPBlinkOcrRecognizerResult*)result;
            
            [self showResultViewWithResult:blinkOcrResult];
        }
    };
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanninvViewController didFinishDetectionWithResult:(PPDetectorResult *)result {

}

/**
 * Since we setup to return full dewarped image in coordinatorWithError:, this method will be called each time document is detected. Then, we will store last found image to a variable so we can present it if needed
 */
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

#pragma mark - UI, Result view
/**
 * This section contains UI setupt of showing scanning result and dewarped image of cheque and does not contain SDK-related content
 */

- (void)showResultViewWithResult:(PPBlinkOcrRecognizerResult*)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[result parsedResultForName:US_CHEQUE_OCR_LINE parserGroup:US_CHEQUE_OCR_LINE] forKey:@"OCR Line"];
    PPResultViewController *resultView = [[PPResultViewController alloc] initWithTitle:@"US CHEQUE" labels:dict subTitle:@"" labelOrder:nil];
    [self.scanningViewController addChildViewController:resultView];
    resultView.view.alpha = 0.0f;
    [self.scanningViewController.view addSubview:resultView.view];
    [resultView didMoveToParentViewController:self.scanningViewController];
    resultView.delegate = self;
    
    
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:resultView.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0.0]];
    
    [self.scanningViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         resultView.view.alpha = 0.95f;
                     }];
}

- (void)buttonCloseDidTap:(PPResultViewController *)viewController {
    self.overlay.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         viewController.view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [viewController removeFromParentViewController];
                         [viewController.view removeFromSuperview];
                         [self.scanningViewController resumeScanningAndResetState:YES];
                     }];
}

- (void)buttonRightDidTap:(PPResultViewController *)viewController {
    NSMutableDictionary *temp = [viewController.labelMap mutableCopy];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temp
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)buttonMiddleDidTap:(PPResultViewController *)viewController {
    [self showResultImage];
}

- (void)showResultImage {
    if(self.succesfulImage) return;
    self.succesfulImage = [[UIImageView alloc] init];
    self.succesfulImage.userInteractionEnabled = YES;
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSuccesfulImage:)];
    tapRecognizer.delegate = self;
    [self.succesfulImage addGestureRecognizer:tapRecognizer];
    
    float finalAlpha = 1.0;
    
    self.blurView = [[UIView alloc] init];
    
    UIView *blurBackground;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurBackground = blurEffectView;
    
    self.blurView.backgroundColor = [UIColor clearColor];
    
    [self.scanningViewController.view addSubview:self.blurView];
    [self.blurView addSubview:blurBackground];
    
    UIGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSuccesfulImage:)];
    tapRecognizer2.delegate = self;
    [self.blurView addGestureRecognizer:tapRecognizer2];
    
    [self.blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [blurBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:blurBackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:blurBackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:blurBackground attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:blurBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    
    UIButton *buttonClose = [[UIButton alloc] init];
    [buttonClose setTranslatesAutoresizingMaskIntoConstraints:NO];
    [buttonClose setTitle:@"Close" forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    buttonClose.contentEdgeInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
    [self.blurView addSubview:buttonClose];
    
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:buttonClose attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:buttonClose attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]];
    
    UIButton *buttonSave = [[UIButton alloc] init];
    [buttonSave setTranslatesAutoresizingMaskIntoConstraints:NO];
    [buttonSave setTitle:@"Save to Gallery" forState:UIControlStateNormal];
    [buttonSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    buttonSave.contentEdgeInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
    [self.blurView addSubview:buttonSave];
    
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:buttonSave attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20.0]];
    [self.blurView addConstraint:[NSLayoutConstraint constraintWithItem:buttonSave attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.blurView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]];
    
    [buttonClose addTarget:self
                    action:@selector(closeResultImage)
          forControlEvents:UIControlEventTouchUpInside];
    [buttonSave addTarget:self
                   action:@selector(blurViewSave)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.succesfulImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.succesfulImage.image = self.imageMetadata.image;
    [self.succesfulImage.layer setCornerRadius:5.0f];
    [self.succesfulImage.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.succesfulImage.layer setBorderWidth:1.0f];
    self.succesfulImage.layer.masksToBounds = YES;
    
    [self.scanningViewController.view addSubview:self.succesfulImage];
    
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    float aspectRatio = self.imageMetadata.image.size.height / self.imageMetadata.image.size.width;
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeWidth multiplier:0.0 constant:1.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeHeight multiplier:0.0 constant:1.0];
    
    
    width = [NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0.0];
    width.priority = 999;
    height = [NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeWidth multiplier:aspectRatio constant:0.0];
    height.priority = 999;
    [self.scanningViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.succesfulImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.scanningViewController.view attribute:NSLayoutAttributeHeight multiplier:0.6 constant:0.0]];
    [self.scanningViewController.view addConstraint:width];
    [self.scanningViewController.view addConstraint:height];
    [self.scanningViewController.view layoutIfNeeded];
    
    self.succesfulImage.alpha = 0.0;
    self.blurView.alpha = 0.0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.blurView.alpha = finalAlpha;
                         self.succesfulImage.alpha = 1.0;
                     }];
}

- (void)closeResultImage {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.succesfulImage.alpha = 0.0;
                         self.blurView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.blurView removeFromSuperview];
                         [self.succesfulImage removeFromSuperview];
                     }];
    self.succesfulImage = nil;
}

- (void)didTapSuccesfulImage:(UITapGestureRecognizer *)recognizer {
    if (self.succesfulImage != nil) {
        [self closeResultImage];
    }
}

- (void) blurViewSave {
    if (self.succesfulImage != nil) {
        UIImageWriteToSavedPhotosAlbum(self.imageMetadata.image,
                                       nil,nil,nil);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.succesfulImage != nil) {
        return true;
    }
    return false;
}

@end
