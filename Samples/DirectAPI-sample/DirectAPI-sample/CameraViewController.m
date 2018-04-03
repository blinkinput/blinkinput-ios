//
//  ViewController.m
//  Camera-Sample
//
//  Created by Jura on 09/08/15.
//  Copyright © 2015 MicroBlink. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>
#import <MicroBlink/MicroBlink.h>

@interface CameraViewController () <AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, MBScanningRecognizerRunnerDelegate>

@property (weak, nonatomic) IBOutlet CameraView *cameraView;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) MBRecognizerRunner *recognizerRunner;
@property (nonatomic, strong) MBPdf417Recognizer *pdf417Recognizer;

@property (nonatomic) BOOL pauseRecognition;

@end

@implementation CameraViewController

static NSString *rawOcrParserId = @"Raw ocr";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Valid until: 2018-04-29
    [[MBMicroblinkSDK sharedInstance] setLicenseResource:@"license" withExtension:@"txt" inSubdirectory:@"License" forBundle:[NSBundle mainBundle]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Note that the app delegate controls the device orientation notifications required to use the device orientation.
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(deviceOrientation) || UIDeviceOrientationIsLandscape(deviceOrientation)) {
        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.cameraView.layer;
        previewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
    }
}

- (IBAction)closeCamera:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animate {
    [super viewDidAppear:animate];
    [self startCaptureSession];
};

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(captureSessionDidStartRunningNotification:)
                                                 name:AVCaptureSessionDidStartRunningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(captureSessionDidStopRunningNotification:)
                                                 name:AVCaptureSessionDidStopRunningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(captureSessionRuntimeErrorNotification:)
                                                 name:AVCaptureSessionRuntimeErrorNotification
                                               object:nil];
}

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNotificationObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCaptureSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotificationObserver];
}

- (void)appplicationWillResignActive:(NSNotification*)note {
    NSLog(@"Will resign active!");
}

- (void)appplicationWillEnterForeground:(NSNotification*)note {
    NSLog(@"appplicationWillEnterForeground!");
    [self startCaptureSession];
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification*)note {
    NSLog(@"applicationDidEnterBackgroundNotification!");
    [self stopCaptureSession];
}

- (void)applicationWillTerminateNotification:(NSNotification*)note {
    NSLog(@"applicationWillTerminateNotification!");
}

- (void)captureSessionDidStartRunningNotification:(NSNotification*)note {
    NSLog(@"captureSessionDidStartRunningNotification!");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cameraPausedLabel.alpha = 0.0;
    }];
}

- (void)captureSessionDidStopRunningNotification:(NSNotification*)note {
    NSLog(@"captureSessionDidStopRunningNotification!");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cameraPausedLabel.alpha = 1.0;
    }];
}

- (void)captureSessionRuntimeErrorNotification:(NSNotification*)note {
    NSLog(@"captureSessionRuntimeErrorNotification!");
}


- (void)startCaptureSession {
    
    // Create session
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    // Init the device inputs
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack]
                                                                              error:nil];
    [self.captureSession addInput:videoInput];
    
    // setup video data output
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [self.captureSession addOutput:videoDataOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [videoDataOutput setSampleBufferDelegate:self queue:queue];
    
    // Setup the preview view.
    self.cameraView.session = self.captureSession;
    
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
    
    self.pdf417Recognizer = [[MBPdf417Recognizer alloc] init];
    
    [recognizers addObject:self.pdf417Recognizer];
    
    MBSettings* settings = [[MBSettings alloc] init];
    settings.uiSettings.recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];
    
    self.recognizerRunner = [[MBRecognizerRunner alloc] initWithSettings:settings];
    self.recognizerRunner.scanningRecognizerRunnerDelegate = self;
    
    [self.captureSession startRunning];
}

- (void)stopCaptureSession {
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

// Find a camera with the specificed AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    MBImage *image = [MBImage imageWithCmSampleBuffer:sampleBuffer];
    image.orientation = MBProcessingOrientationLeft;
    if (!self.pauseRecognition) {
        [self.recognizerRunner processImage:image];
    }
}

- (void)recognizerRunnerDidFinish:(MBRecognizerRunner *)recognizerRunner state:(MBRecognizerResultState)state {
    self.pauseRecognition = YES;
    if (self.pdf417Recognizer.result.resultState == MBRecognizerResultStateValid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"PDF417";
            
            // Save the string representation of the code
            NSString *message = [self.pdf417Recognizer.result stringData];
            
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
    } else {
        self.pauseRecognition = NO;
    }
}

@end

