//
//  ViewController.m
//  Templating-Sample
//
//  Created by Dino on 08/06/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "ViewController.h"
#import "MBCroatianIDFrontTemplateRecognizer.h"
#import <MicroBlink/MicroBlink.h>

@interface ViewController () <MBBarcodeOverlayViewControllerDelegate>

@property (nonatomic, strong) MBBarcodeRecognizer *barcodeRecognizer;
@property (nonatomic, strong) MBCroatianIDFrontTemplateRecognizer *croatianIDFrontTemplateRecognizer;

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

- (IBAction)didTapScan:(id)sender {
    
    /** Create recognizers */
    self.croatianIDFrontTemplateRecognizer = [[MBCroatianIDFrontTemplateRecognizer alloc] init];
    
    MBBarcodeOverlaySettings* settings = [[MBBarcodeOverlaySettings alloc] init];
    
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
    
    [recognizers addObject:self.croatianIDFrontTemplateRecognizer.detectorRecognizer];
    
    /** Create recognizer collection */
    settings.uiSettings.recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];
    
    MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings andDelegate:self];
    UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
}

#pragma mark - MBBarcodeOverlayViewControllerDelegate

- (void)barcodeOverlayViewControllerDidFinishScanning:(MBBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBRecognizerResultState)state {
    
    if (state == MBRecognizerResultStateValid) {
        [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Croatian ID Front"
                                                                           message:[self.croatianIDFrontTemplateRecognizer resultDescription]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [barcodeOverlayViewController dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            
            [alert addAction:defaultAction];
            [barcodeOverlayViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}

- (void)barcodeOverlayViewControllerDidTapClose:(MBBarcodeOverlayViewController *)barcodeOverlayViewController {
    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
