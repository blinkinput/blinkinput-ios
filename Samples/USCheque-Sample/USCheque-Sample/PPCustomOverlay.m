//
//  PPCustomOverlay.m
//  USCheque-Sample
//
//  Created by Dino on 11/07/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import "PPCustomOverlay.h"

@interface PPCustomOverlay ()

@property (nonatomic, strong) PPModernViewfinderOverlaySubview *viewfinderSubview;
@property (nonatomic, strong) PPOcrResultOverlaySubview *ocrSubview;

@end

@implementation PPCustomOverlay

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ocrSubview = [[PPOcrResultOverlaySubview alloc] initWithFrame:self.view.bounds];
    [self registerOverlaySubview:self.ocrSubview];
    [self.view addSubview:self.ocrSubview];
    
    self.viewfinderSubview = [[PPModernViewfinderOverlaySubview alloc] init];
    self.viewfinderSubview.moveable = YES;
    self.viewfinderSubview.delegate = self.overlaySubviewsDelegate;
    [self registerOverlaySubview:self.viewfinderSubview];
    [self.view addSubview:self.viewfinderSubview];
}

#pragma mark - Autorotation methods

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.viewfinderSubview.frame = self.view.bounds;
    self.ocrSubview.frame = self.view.bounds;
}
@end
