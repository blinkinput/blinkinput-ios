//
//  CustomOverlay.m
//  pdf417-sample
//
//  Created by Dino Gustin on 05/03/2018.
//  Copyright © 2018 MicroBlink. All rights reserved.
//

#import "CustomOverlay.h"

@interface CustomOverlay() <MBScanningRecognizerRunnerViewDelegate>

@property (nonatomic) MBSettings *settings;

@property (nonatomic) id<MBCustomOverlayViewControllerDelegate> delegate;

@end

@implementation CustomOverlay

+ (instancetype)initFromStoryboardWithSettings:(MBSettings *)settings andDelegate:(nonnull id<MBCustomOverlayViewControllerDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomOverlay *customOverlay = [storyboard instantiateViewControllerWithIdentifier:@"CustomOverlay"];
    customOverlay.settings = settings;
    customOverlay.delegate = delegate;
    customOverlay.overlayViewControllerInterfaceDelegate = customOverlay;
    return customOverlay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recognizerRunnerViewController.scanningRecognizerRunnerViewDelegate = self;
    self.scanningRegion = CGRectMake(0.1, 0.3, 0.8, 0.25);
}

- (void)recognizerRunnerViewControllerDidFinishScanning:(nonnull UIViewController<MBRecognizerRunnerViewController> *)recognizerRunnerViewController state:(MBRecognizerResultState)state {
    [self.delegate customOverlayViewControllerDidFinishScanning:self state:state];
}
- (IBAction)didTapClose:(id)sender {
    [self.delegate customOverlayViewControllerDidTapClose:self];
}

- (nonnull MBSettings *)getSettings {
    return self.settings;
}

@end
