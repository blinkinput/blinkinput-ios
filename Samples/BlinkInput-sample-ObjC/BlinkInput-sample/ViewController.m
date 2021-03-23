//
//  ViewController.m
//  BlinkOCR-sample
//
//  Created by Jura on 02/03/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <BlinkInput/BlinkInput.h>

@interface ViewController () <MBINBarcodeOverlayViewControllerDelegate>

@property (nonatomic, strong) MBINRawParser *rawParser;
@property (nonatomic, strong) MBINParserGroupProcessor *parserGroupProcessor;
@property (nonatomic, strong) MBINBlinkInputRecognizer *blinkInputRecognizer;

@end

@implementation ViewController

- (IBAction)didTapScan:(id)sender {
    
    MBINBarcodeOverlaySettings* settings = [[MBINBarcodeOverlaySettings alloc] init];

    self.rawParser = [[MBINRawParser alloc] init];
    self.parserGroupProcessor = [[MBINParserGroupProcessor alloc] initWithParsers:@[self.rawParser]];
    self.blinkInputRecognizer = [[MBINBlinkInputRecognizer alloc] initWithProcessors:@[self.parserGroupProcessor]];

    /** Create recognizer collection */
    MBINRecognizerCollection *recognizerCollection = [[MBINRecognizerCollection alloc] initWithRecognizers:@[self.blinkInputRecognizer]];
    
    MBINBarcodeOverlayViewController *overlayVC = [[MBINBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];
    UIViewController<MBINRecognizerRunnerViewController>* recognizerRunnerViewController = [MBINViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
}

#pragma mark - MBINBarcodeOverlayViewControllerDelegate

- (void)barcodeOverlayViewControllerDidFinishScanning:(MBINBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBINRecognizerResultState)state {
    
    // check for valid state
    if (state == MBINRecognizerResultStateValid) {
        
        // first, pause scanning until we process all the results
        [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
        
        ViewController __weak *weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"OCR results are:");
            NSLog(@"Raw ocr: %@", weakSelf.rawParser.result.rawText);

            // Show result on the initial screen
            self.labelResult.text = weakSelf.rawParser.result.rawText;
            
            MBINOcrLayout* ocrLayout = weakSelf.parserGroupProcessor.result.ocrLayout;
            NSLog(@"Dimensions of ocrLayout are %@", NSStringFromCGRect(ocrLayout.box));
            
            [barcodeOverlayViewController.recognizerRunnerViewController resumeScanningAndResetState:YES];
        });
    }
}

- (void)barcodeOverlayViewControllerDidTapClose:(MBINBarcodeOverlayViewController *)barcodeOverlayViewController {
    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
