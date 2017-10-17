//
//  ViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 02/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPFieldViewController.h"
#import "PPFormOcrOverlayViewController.h"
#import "PPResultViewController.h"
#import "PPScanElement.h"
#import "ViewController.h"
#import <MicroBlink/MicroBlink.h>
#import <MicroBlink/PPBlinkOcrRecognizerResult.h>
#import "PPParsers.h"
#import "PPSelectedParsersViewController.h"
#import "MBResultTableViewController.h"

@interface ViewController () <PPFormOcrOverlayViewControllerDelegate, PPResultViewControllerDelegate, PPFieldViewControllerDelegate>

@property(nonatomic) NSMutableArray *scanElements;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanElements = [[PPParsers getInitialParsers] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.buttonSettings.hidden = ![PPParsers areSettingsAllowed];
}

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didFindError:(NSError *)error {
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didOutputResults:(NSArray *)results {
}

- (IBAction)didTapScanForm:(id)sender {
    PPCameraCoordinator *coordinator = [self createCordinator];
    [self presentFormScannerWithCoordinator:coordinator];
}
- (IBAction)didTapScanFields:(id)sender {
    PPCameraCoordinator *coordinator = [self createCordinator];
    if (self.scanElements.count > 0) {
        PPFieldViewController *controller = [PPFieldViewController viewControllerFromStoryboard];
        controller.delegate = self;
        controller.coordinator = coordinator;
        controller.scanElements = self.scanElements;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No Scan Elements Present"
                                     message:@"Tap Settings to add Scan Elements"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (PPCameraCoordinator *)createCordinator {
    NSError *error;
    if ([PPCameraCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:&error]) {
        NSString *messageString = [error localizedDescription];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:messageString
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        return nil;
    }
    PPSettings *settings = [[PPSettings alloc] init];
    settings.licenseSettings.licenseKey = @LICENSE_KEY;
    PPCameraCoordinator *coordinator = [[PPCameraCoordinator alloc] initWithSettings:settings];
    return coordinator;
}

- (void)formOcrOverlayViewControllerWillClose:(PPFormOcrOverlayViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)formOcrOverlayViewController:(PPFormOcrOverlayViewController *)vc didFinishScanningWithElements:(NSArray *)scanElements {
    [self dismissViewControllerAnimated:YES
                             completion:^(void) {
                               [self showResultWithScanElements:scanElements];
                             }];
}

- (void)presentFormScannerWithCoordinator:(PPCameraCoordinator *)coordinator {
    if (coordinator == nil)
        return;
    if (self.scanElements.count > 0) {
        PPFormOcrOverlayViewController *overlayViewController = [PPFormOcrOverlayViewController allocFromNibName:@"PPFormOcrOverlayViewController"];

        overlayViewController.scanElements = self.scanElements;
        overlayViewController.coordinator = coordinator;
        overlayViewController.delegate = self;

        UIViewController<PPScanningViewController> *scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:nil overlayViewController:overlayViewController coordinator:coordinator error:nil];

        [self presentViewController:scanningViewController animated:YES completion:nil];
    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No Scan Elements Present"
                                     message:@"Tap Settings to add Scan Elements"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)buttonCloseDidTap:(PPResultViewController *)viewController {
    [UIView animateWithDuration:0.3
        delay:0.0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
          viewController.view.alpha = 0.0f;
        }
        completion:^(BOOL finished) {
          [viewController.view removeFromSuperview];
          [viewController removeFromParentViewController];
        }];
}

- (void)buttonRightDidTap:(PPResultViewController *)viewController {
}

- (void)fieldViewControllerWillClose:(PPFieldViewController *)vc {
}

- (void)fieldViewController:(PPFieldViewController *)vc didFinishScanningWithElements:(NSArray *)scanElements {
    [self showResultWithScanElements:scanElements];
}

- (void)showResultWithScanElements:(NSArray *)scanElements {
    
    MBResultTableViewController *vc = [MBResultTableViewController viewControllerFromStoryBoard];
    vc.scanElements = scanElements;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)buttonSettingsDidTap:(id)sender {
    PPSelectedParsersViewController *someViewController = [PPSelectedParsersViewController viewControllerFromStoryboard];
    someViewController.scanElements = self.scanElements;

    [self.navigationController pushViewController:someViewController animated:YES];
}

@end
