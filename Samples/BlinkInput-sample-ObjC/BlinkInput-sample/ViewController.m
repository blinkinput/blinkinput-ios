//
//  ViewController.m
//  BlinkOCR-sample
//
//  Created by Jura on 02/03/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <BlinkInput/BlinkInput.h>

@interface ViewController () <MBIBarcodeOverlayViewControllerDelegate>

@property (nonatomic, strong) MBIRawParser *rawParser;
@property (nonatomic, strong) MBIParserGroupProcessor *parserGroupProcessor;
@property (nonatomic, strong) MBIBlinkInputRecognizer *blinkInputRecognizer;

@end

@implementation ViewController

- (IBAction)didTapScan:(id)sender {
    
    MBIBarcodeOverlaySettings* settings = [[MBIBarcodeOverlaySettings alloc] init];

    self.rawParser = [[MBIRawParser alloc] init];
    self.parserGroupProcessor = [[MBIParserGroupProcessor alloc] initWithParsers:@[self.rawParser]];
    self.blinkInputRecognizer = [[MBIBlinkInputRecognizer alloc] initWithProcessors:@[self.parserGroupProcessor]];

    /** Create recognizer collection */
    MBIRecognizerCollection *recognizerCollection = [[MBIRecognizerCollection alloc] initWithRecognizers:@[self.blinkInputRecognizer]];
    
    MBIBarcodeOverlayViewController *overlayVC = [[MBIBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];
    UIViewController<MBIRecognizerRunnerViewController>* recognizerRunnerViewController = [MBIViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
}

#pragma mark - MBIBarcodeOverlayViewControllerDelegate

- (void)barcodeOverlayViewControllerDidFinishScanning:(MBIBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBIRecognizerResultState)state {
    
    // check for valid state
    if (state == MBIRecognizerResultStateValid) {
        
        // first, pause scanning until we process all the results
        [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
        
        ViewController __weak *weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"OCR results are:");
            NSLog(@"Raw ocr: %@", weakSelf.rawParser.result.rawText);

            // Show result on the initial screen
            self.labelResult.text = weakSelf.rawParser.result.rawText;
            
            MBIOcrLayout* ocrLayout = weakSelf.parserGroupProcessor.result.ocrLayout;
            NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect(ocrLayout.box));
            
            [barcodeOverlayViewController.recognizerRunnerViewController resumeScanningAndResetState:YES];
        });
    }
}

- (void)barcodeOverlayViewControllerDidTapClose:(MBIBarcodeOverlayViewController *)barcodeOverlayViewController {
    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
