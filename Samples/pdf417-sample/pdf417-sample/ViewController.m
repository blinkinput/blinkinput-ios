//
//  ViewController.m
//  pdf417-sample
//
//  Created by Jura on 16/07/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MicroBlink/MicroBlink.h>

#import "PPCameraOverlayViewController.h"

@interface ViewController () <PPScanningDelegate, UIAlertViewDelegate>

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
    
    
    /** 2. Setup the license key */
    
    // Visit www.microblink.com to get the license key for your app
    // Valid until 2017-12-21
    settings.licenseSettings.licenseKey = @"VDDXAB7K-PS5FKSZ5-K3KRFFV6-TFEXOVAI-IRQEB5EH-WUUZV54Z-JF3VJKCF-JX3B57NC";
    
    
    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Remove undesired recognizers (added below) for optimal performance.
     */
    
    
    {// Remove this code if you don't need to scan Pdf417
        // To specify we want to perform PDF417 recognition, initialize the PDF417 recognizer settings
        PPPdf417RecognizerSettings *pdf417RecognizerSettings = [[PPPdf417RecognizerSettings alloc] init];
        
        /** You can modify the properties of pdf417RecognizerSettings to suit your use-case */
        
        // Add PDF417 Recognizer setting to a list of used recognizer settings
        [settings.scanSettings addRecognizerSettings:pdf417RecognizerSettings];
    }
    
    {// Remove this code if you don't need to scan QR codes
        // To specify we want to perform recognition of other barcode formats, initialize the ZXing recognizer settings
        PPBarcodeRecognizerSettings *barcodeRecognizerSettings = [[PPBarcodeRecognizerSettings alloc] init];
        
        /** You can modify the properties of zxingRecognizerSettings to suit your use-case (i.e. add other types of barcodes like QR, Aztec or EAN)*/
        barcodeRecognizerSettings.scanQR = YES; // we use just QR code
        
        
        // Add ZXingRecognizer setting to a list of used recognizer settings
        [settings.scanSettings addRecognizerSettings:barcodeRecognizerSettings];
    }
    
    /** 4. Initialize the Scanning Coordinator object */
    
    PPCameraCoordinator *coordinator = [[PPCameraCoordinator alloc] initWithSettings:settings];
    
    return coordinator;
}

- (void)showCoordinatorError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                             message:[error localizedDescription]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)didTapScan:(id)sender {
    
    /** Instantiate the scanning coordinator */
    NSError *error;
    PPCameraCoordinator *coordinator = [self coordinatorWithError:&error];
    
    /** If scanning isn't supported, show an error */
    if (coordinator == nil) {
        [self showCoordinatorError:error];
        return;
    }
    
    /** Create new scanning view controller */
    UIViewController<PPScanningViewController>* scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self coordinator:coordinator error:nil];
    
    // Allow scanning view controller to autorotate
    scanningViewController.autorotate = YES;
    scanningViewController.supportedOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
    /** Present the scanning view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

- (IBAction)didTapScanCustomUI:(id)sender {
    /** Instantiate the scanning coordinator */
    
    NSError *error;
    PPCameraCoordinator *coordinator = [self coordinatorWithError:&error];
    
    /** If scanning isn't supported, show an error */
    if (coordinator == nil) {
        [self showCoordinatorError:error];
        return;
    }
    
    /** Present the scanning view controller */
    
    /** Init scanning view controller custom overlay */
    PPCameraOverlayViewController *overlayVC = [[PPCameraOverlayViewController alloc] init];
    
    /** Create new scanning view controller with desired custom overlay */
    UIViewController<PPScanningViewController>* scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self overlayViewController:overlayVC coordinator:coordinator error:nil];
    
    /** Present the scanning view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

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
    
    // If results are empty, continue scanning without any actions
    if (results == nil || [results count] == 0) {
        return;
    }
    
    // first, pause scanning until we process all the results
    [scanningViewController pauseScanning];
    
    NSString* message;
    NSString* title;
    
    for (PPRecognizerResult* result in results) {
        if ([result isKindOfClass:[PPBarcodeRecognizerResult class]]) {
            /** One of ZXing codes was detected */
               
            PPBarcodeRecognizerResult *barcodeResult = (PPBarcodeRecognizerResult *)result;
        
            title = @"QR code";
            
            // Save the string representation of the code
            message = [barcodeResult stringUsingGuessedEncoding];
        }
        if ([result isKindOfClass:[PPPdf417RecognizerResult class]]) {
            /** Pdf417 code was detected */
             
            PPPdf417RecognizerResult *pdf417Result = (PPPdf417RecognizerResult *)result;
                
            title = @"PDF417";
                
            // Save the string representation of the code
            message = [pdf417Result stringUsingGuessedEncoding];
        }
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    
    [alertController addAction:okAction];
    
    [scanningViewController presentViewController:alertController animated:YES completion:nil];
}

@end
