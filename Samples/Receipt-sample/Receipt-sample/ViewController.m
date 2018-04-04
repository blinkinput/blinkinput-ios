//
//  ViewController.m
//  Receipt-sample
//
//  Created by Jura on 21/10/15.
//  Copyright © 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MicroBlink/MicroBlink.h>

@interface ViewController () <MBBarcodeOverlayViewControllerDelegate>

@property (nonatomic, strong) MBRawParser *rawParser;
@property (nonatomic, strong) MBParserGroupProcessor *parserGroupProcessor;
@property (nonatomic, strong) MBBlinkInputRecognizer *blinkInputRecognizer;

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

- (void)setupRawParser {
    self.rawParser = [[MBRawParser alloc] init];
    
    MBOcrEngineOptions *options = [[MBOcrEngineOptions alloc] init];

    options.minimalLineHeight = 10;
    options.maximalLineHeight = 50;
    options.maxCharsExpected = 3000;
    options.colorDropoutEnabled = NO;

    // initialize new char whitelist
    NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];

    // Add chars 'a'-'z'
    for (int c = 'a'; c <= 'z'; c++) {
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:c font:MB_OCR_FONT_ANY]];
    }

    // Add chars 'A'-'Z'
    for (int c = 'A'; c <= 'Z'; c++) {
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:c font:MB_OCR_FONT_ANY]];
    }

    // Add chars '0'-'9'
    for (int c = '0'; c <= '9'; c++) {
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:c font:MB_OCR_FONT_ANY]];
    }

    // Add chars ".-$%"
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:'.' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:'-' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:'$' font:MB_OCR_FONT_ANY]];
    [charWhitelist addObject:[MBOcrCharKey keyWithCode:'%' font:MB_OCR_FONT_ANY]];

    // set the whitelist
    options.charWhitelist = charWhitelist;
    
    self.rawParser.ocrEngineOptions = options;

}

- (IBAction)didTapScan:(id)sender {

    MBBarcodeOverlaySettings* settings = [[MBBarcodeOverlaySettings alloc] init];
    
    [self setupRawParser];
    
    self.parserGroupProcessor = [[MBParserGroupProcessor alloc] initWithParsers:@[self.rawParser]];
    self.blinkInputRecognizer = [[MBBlinkInputRecognizer alloc] initWithProcessors:@[self.parserGroupProcessor]];
    
    /** Create recognizer collection */
    settings.uiSettings.recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:@[self.blinkInputRecognizer]];
    
    MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings andDelegate:self];
    UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
}

#pragma mark - MBBarcodeOverlayViewControllerDelegate

- (void)barcodeOverlayViewControllerDidFinishScanning:(MBBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBRecognizerResultState)state {
    
    // check for valid state
    if (state == MBRecognizerResultStateValid) {
        
        // first, pause scanning until we process all the results
        [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"OCR results are:");
            NSLog(@"Raw ocr: %@", self.rawParser.result.rawText);
            
            MBOcrLayout* ocrLayout = self.parserGroupProcessor.result.ocrLayout;
            NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect(ocrLayout.box));
            
            [barcodeOverlayViewController.recognizerRunnerViewController resumeScanningAndResetState:YES];
        });
    }
}

- (void)barcodeOverlayViewControllerDidTapClose:(MBBarcodeOverlayViewController *)barcodeOverlayViewController {
    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
