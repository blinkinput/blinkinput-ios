//
//  MicroBlink.h
//  MicroBlinkFramework
//
//  Created by Jurica Cerovec on 3/29/12.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#ifndef PhotoPayFramework_MicroBlink_h
#define PhotoPayFramework_MicroBlink_h

// Common API
#import "MBMicroblinkSDK.h"
#import "MBViewControllerFactory.h"
#import "PPApp.h"
#import "MBSettings.h"
#import "MBImage.h"
#import "MBMicroBlinkInitialization.h"

/*  UI  */
// Overlays
#import "MBModernBaseOverlayViewController.h"
#import "MBBarcodeOverlayViewController.h"
#import "MBBaseBarcodeOverlayViewController.h"
#import "MBScanningRecognizerRunnerViewController.h"
#import "MBBasePhotoPayOverlayViewController.h"
#import "MBPhotopayOverlayViewController.h"

// Permission denied view controller
#import "MBPermissionDeniedViewController.h"

// Overlay subviews
#import "PPModernOcrResultOverlaySubview.h"
#import "MBModernViewfinderOverlaySubview.h"
#import "PPOcrResultOverlaySubview.h"
#import "PPBlurredFieldOfViewOverlaySubview.h"
#import "MBDotsOverlaySubview.h"
#import "PPFieldOfViewOverlaySubview.h"
#import "PPModernToastOverlaySubview.h"
#import "PPOcrLineOverlaySubview.h"
#import "PPToastOverlaySubview.h"
#import "MBViewFinderOverlaySubview.h"
#import "MBIdDocumentOverlaySubview.h"
#import "MBGlareStatusOverlaySubview.h"
#import "MBTapToFocusOverlaySubview.h"

// Delegates
#import "MBRecognizerRunnerMetadataDelegates.h"
#import "MBRecognizerRunnerViewMetadataDelegates.h"

#import "MBBarcodeOverlayViewControllerDelegate.h"
#import "MBRecognizerRunnerViewControllerDelegate.h"
#import "MBDetectionRecognizerRunnerViewDelegate.h"
#import "MBDebugRecognizerRunnerViewDelegate.h"
#import "MBScanningRecognizerRunnerViewDelegate.h"
#import "MBOcrRecognizerRunnerViewDelegate.h"

#import "MBDebugRecognizerRunnerDelegate.h"
#import "MBDetectionRecognizerRunnerDelegate.h"
#import "MBScanningRecognizerRunnerDelegate.h"
#import "MBOcrRecognizerRunnerDelegate.h"

#import "MBOverlayViewControllerInterface.h"

// Runners
#import "MBRecognizerRunner.h"

// Collection
#import "MBRecognizerCollection.h"

// Settings
#import "MBBarcodeOverlaySettings.h"

// Exception
#import "MBException.h"

// Detectors
#import "MBQuadrangle.h"
#import "MBDisplayableQuadDetection.h"
#import "MBDisplayablePointsDetection.h"

#import "MBSuccessFrameGrabberRecognizer.h"
#import "MBFrameGrabberRecognizer.h"

#import "MBScanningRecognizerRunnerViewDelegate.h"

// Recognizers
#import "PPBlinkInputRecognizers.h"

#endif
