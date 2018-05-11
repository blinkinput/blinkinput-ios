//
//  RootViewController.m
//  DirectAPI-Sample
//
//  Created by Jura on 09/08/15.
//  Copyright © 2015 MicroBlink. All rights reserved.
//

#import "RootViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MicroBlink/MicroBlink.h>

@interface RootViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBScanningRecognizerRunnerDelegate>

@property (nonatomic, strong) MBRecognizerRunner *recognizerRunner;
@property (nonatomic, strong) MBPdf417Recognizer *pdf417Recognizer;

@end

@implementation RootViewController

static NSString* rawOcrParserId = @"RawOcrParser";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Valid until: 2018-10-06
    [[MBMicroblinkSDK sharedInstance] setLicenseResource:@"license-direct" withExtension:@"txt" inSubdirectory:@"License" forBundle:[NSBundle mainBundle]];
    [self setupRecognizerRunner];
}

- (IBAction)openImagePicker:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    
    // Displays a control that allows the user to choose only photos
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for trimming movies.
    imagePicker.allowsEditing = NO;
    
    // Shows default camera control overlay over camera preview.
    imagePicker.showsCameraControls = YES;
    
    // set delegate
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // Handle a still image capture
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];
        [self processImageRunner: originalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupRecognizerRunner {
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
    
    self.pdf417Recognizer = [[MBPdf417Recognizer alloc] init];
    [recognizers addObject:self.pdf417Recognizer];
    
    MBRecognizerCollection *recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];
    
    self.recognizerRunner = [[MBRecognizerRunner alloc] initWithRecognizerCollection:recognizerCollection];
    self.recognizerRunner.scanningRecognizerRunnerDelegate = self;
}

- (void)processImageRunner:(UIImage *)originalImage {
    MBImage *image = [MBImage imageWithUIImage:originalImage];
    image.cameraFrame = YES;
    image.orientation = MBProcessingOrientationLeft;
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.microblink.DirectAPI-sample", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_serialQueue, ^{
        [self.recognizerRunner processImage:image];
    });
}

- (void)recognizerRunner:(nonnull MBRecognizerRunner *)recognizerRunner didFinishScanningWithState:(MBRecognizerResultState)state {
    if (state == MBRecognizerResultStateValid) {
        
        RootViewController __weak *weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"PDF417";
            
            // Save the string representation of the code
            NSString *message = [weakSelf.pdf417Recognizer.result stringData];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                                             }];
            
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

@end

