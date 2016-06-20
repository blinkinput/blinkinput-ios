//
//  PPFieldOcrOverlayViewController.h
//  SegmentScanDemo
//
//  Created by Dino on 07/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPFieldItemViewController.h"
#import "PPScanElement.h"
#import <MicroBlink/MicroBlink.h>

@protocol PPFieldViewControllerDelegate;

@interface PPFieldViewController : UIViewController <PPFieldOverlayItemViewControllerDelegate, PPScanningDelegate>

@property(nonatomic) PPCameraCoordinator *coordinator;

@property(nonatomic, strong) NSArray *scanElements;

@property(nonatomic) id<PPFieldViewControllerDelegate> delegate;

+ (instancetype)viewControllerFromStoryboard;

@end

@protocol PPFieldViewControllerDelegate

- (void)fieldViewControllerWillClose:(PPFieldViewController *)vc;

- (void)fieldViewController:(PPFieldViewController *)vc didFinishScanningWithElements:(NSArray *)scanElements;

@end