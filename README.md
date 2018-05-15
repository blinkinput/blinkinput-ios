<p align="center" >
  <a href="http://www.microblink.com">
    <img src="https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/logo-microblink.png" alt="MicroBlink" title="MicroBlink" />
  </a>
</p>

[![Build Status](https://travis-ci.org/BlinkOCR/blinkocr-ios.png)](https://travis-ci.org/BlinkOCR/blinkocr-ios.png)
[![Pod Version](http://img.shields.io/cocoapods/v/PPBlinkOCR.svg?style=flat)](http://cocoadocs.org/docsets/PPBlinkOCR/)

# BlinkInput SDK for real time text recognition

BlinkInput SDK is a state-of-the-art OCR module for mobile devices. It's OCR technology is optimized specifically for mobile devices and architectures. This allows faster results and lower error rate than regular desktop-based OCR software. BlinkInput features: 

- integrated camera management
- integrated **text parsing** feature for fields like IBANs, prices, email addresses, urls, and many more!
- layered API, allowing everything from simple integration to complex UX customizations.
- lightweight and no internet connection required
- enteprise-level security standards
- support for barcode scanning

BlinkInput is a part of family of SDKs developed by [MicroBlink](http://www.microblink.com) for optical text recognition, barcode scanning, ID document scanning and many others. 

BlinkInput powers [PhotoMath app](https://photomath.net/en/) where it's used to [recognize mathematic expressions](https://vimeo.com/109405701) in real time.

# Table of contents

* [Requirements](#requirements)
* [Quick Start](#quickStart)
* [Advanced BlinkInput integration instructions](#advancedIntegration)
    * [UI customizations of built-in `MBOverlayViewControllers` and `MBOverlaySubviews`](#uiCustomizations)
        * [Built-in overlay view controllers and overlay subviews](#builtInUIComponents)
    * [Using `MBBarcodeOverlayViewController`](#mbBarcodeOverlayViewcontroller)
    * [Custom overlay view controller](#recognizerRunnerViewController)
    * [Direct processing API](#directAPI)
* [`MBRecognizer` and available recognizers](#availableRecognizers)
    * [The `MBRecognizer` concept](#recognizerConcept)
    * [`MBRecognizerCollection` concept](#recognizerBCollection)
    * [List of available recognizers](#recognizerList)
        * [Frame Grabber Recognizer](#frameGrabberRecognizer)
        * [Success Frame Grabber Recognizer](#successFrameGrabberRecognizer)
        * [PDF417 recognizer](#pdf417Recognizer)
        * [Barcode recognizer](#barcodeRecognizer)
        * [BlinkInput recognizer](#blinkInputRecognizer)
        * [Detector recognizer](#detectorRecognizer)
* [`Field by field` scanning feature](#fieldScan)
    * [`Field by field` feature](#fieldByFieldFeature)
* [`MBProcessor` and `MBParser`](#processorsAndParsers)
    * [The `MBProcessor` concept](#processorConcept)
    * [List of available processors](#processorList)
        * [Image Return Processor](#imageReturnProcessor)
        * [Parser Group Processor](#parserGroupProcessor)
    * [The `MBParser` concept](#parserConcept)
    * [List of available parsers](#parserList)
        * [Amount Parser](#amountParser)
        * [Date Parser](#dateParser)
        * [Email Parser](#emailParser)
        * [IBAN Parser](#ibanParser)
        * [License Plates Parser](#licensePlatesParser)
        * [Raw Parser](#rawParser)
        * [Regex Parser](#regexParser)
        * [TopUp Parser](#topUpParser)
        * [VIN (*Vehicle Identification Number*) Parser](#vinParser)
* [Scanning generic documents with Templating API](#detectorTemplating)
        * [The `MBProcessorGroup` component](#processorGroup)
        * [List of available dewarp policies](#dewarpPolicyList)
        * [The `MBTemplatingClass` component](#templatingClass)
        * [Implementing the `MBTemplatingClassifier`](#implementingTemplatingClassifier)
* [The `MBDetector` concept](#detectorConcept)
    * [List of available detectors](#detectorList)
        * [Document Detector](#documentDetector)
        * [MRTD Detector](#mrtdDetector)
* [Troubleshooting](#troubleshoot)
    * [Integration problems](#integrationTroubleshoot)
    * [SDK problems](#sdkTroubleshoot)
    * [Frequently asked questions and known problems](#faq)
* [Additional info](#info)

# <a name="requirements"></a> Requirements

SDK package contains Microblink framework and one or more sample apps which demonstrate framework integration. The framework can be deployed in iOS 8.0 or later, iPhone 4S or newer and iPad 2 or newer.

SDK performs significantly better when the images obtained from the camera are focused. Because of that, the SDK can have lower performance on iPad 2 and iPod Touch 4th gen devices, which [don't have camera with autofocus](http://www.adweek.com/socialtimes/ipad-2-rear-camera-has-tap-for-auto-exposure-not-auto-focus/12536). 

# <a name="quickStart"></a> Quick Start

## Getting started with BlinkInput SDK

This Quick Start guide will get you up and performing OCR scanning as quickly as possible. All steps described in this guide are required for the integration.

This guide sets up basic Raw OCR parsing and price parsing at the same time. It closely follows the BlinkOCR-sample app. We highly recommend you try to run the sample app. The sample app should compile and run on your device, and in the iOS Simulator. 

The source code of the sample app can be used as the reference during the integration.

### 1. Initial integration steps

#### Using CocoaPods

- If you wish to use version v1.2.0 or above, you need to install [Git Large File Storage](https://git-lfs.github.com) by running these comamnds:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**

- Project dependencies to be managed by CocoaPods are specified in a file called `Podfile`. Create this file in the same directory as your Xcode project (`.xcodeproj`) file.

- Copy and paste the following lines into the TextEdit window:  

```ruby
platform :ios, '9.0'
pod 'PPBlinkOCR', '~> 4.0.0'
```

- Install the dependencies in your project:

```shell 
$ pod install
``` 

- From now on, be sure to always open the generated Xcode workspace (`.xcworkspace`) instead of the project file when building your project:

```shell 
open <YourProjectName>.xcworkspace
```
   
#### Integration without CocoaPods

-[Download](https://github.com/blinkinput/blinkinput-ios/releases) latest release (Download .zip or .tar.gz file starting with BlinkID. DO NOT download Source Code as GitHub does not fully support Git LFS)

OR

Clone this git repository:

- If you wish to clone version v1.4.0 or above, you need to install [Git Large File Storage](https://git-lfs.github.com) by running these comamnds:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**

- To clone, run the following shell command:

```shell
git clone git@github.com:blinkinput/blinkinput-ios.git
```

- Copy MicroBlink.framework and MicroBlink.bundle to your project folder.

- In your Xcode project, open the Project navigator. Drag the MicroBlink.framework and MicroBlink.bundle files to your project, ideally in the Frameworks group, together with other frameworks you're using. When asked, choose "Create groups", instead of the "Create folder references" option.

![Adding MicroBlink.embeddedframework to your project](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/01%20-%20Add%20Framework.jpg)

- Since Microblink.framework is a dynamic framework, you also need to add it to embedded binaries section in General settings of your target.

![Adding MicroBlink.framework to embedded binaries](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/03%20-%20Embed%20Binaries.png)

- Include the additional frameworks and libraries into your project in the "Linked frameworks and libraries" section of your target settings. 

    - AudioToolbox.framework
    - AVFoundation.framework
    - CoreMedia.framework
    - libc++.tbd
    - libiconv.tbd
    - libz.tbd
    
![Adding Apple frameworks to your project](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/02%20-%20Add%20Libraries.jpg)
    
### 2. Referencing header file
    
In files in which you want to use scanning functionality place import directive.

Swift

```swift
import MicroBlink
```

Objective-C

```objective-c
#import <MicroBlink/MicroBlink.h>
```
    
### 3. Initiating the scanning process
    
To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Also, for initialization purposes, the ViewController which initiates the scan have private prperties for [`MBRawParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRawParser.html), [`MBParserGroupProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBParserGroupProcessor.html) and [`MBBlinkInputRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBlinkInputRecognizer.html), so we know how to obtain result.

```swift
class ViewController: UIViewController, MBBarcodeOverlayViewControllerDelegate  {
    
    var rawParser: MBRawParser?
    var parserGroupProcessor: MBParserGroupProcessor?
    var blinkInputRecognizer: MBBlinkInputRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapScan(_ sender: AnyObject) {
        
        let settings = MBBarcodeOverlaySettings()
        rawParser = MBRawParser()
        parserGroupProcessor = MBParserGroupProcessor(parsers: [rawParser!])
        blinkInputRecognizer = MBBlinkInputRecognizer(processors: [parserGroupProcessor!])
        
        let recognizerList = [self.blinkInputRecognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}
```


```objective-c
@interface ViewController () <MBBarcodeOverlayViewControllerDelegate>

@property (nonatomic, strong) MBRawParser *rawParser;
@property (nonatomic, strong) MBParserGroupProcessor *parserGroupProcessor;
@property (nonatomic, strong) MBBlinkInputRecognizer *blinkInputRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)didTapScan:(id)sender {
    
    MBBarcodeOverlaySettings* settings = [[MBBarcodeOverlaySettings alloc] init];

    self.rawParser = [[MBRawParser alloc] init];
    self.parserGroupProcessor = [[MBParserGroupProcessor alloc] initWithParsers:@[self.rawParser]];
    self.blinkInputRecognizer = [[MBBlinkInputRecognizer alloc] initWithProcessors:@[self.parserGroupProcessor]];

    /** Create recognizer collection */
    MBRecognizerCollection *recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:@[self.blinkInputRecognizer]];
    
    MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];
    UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];

}

@end
```
    
### 4. Registering for scanning events
    
In the previous step, you instantiated [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html) object with a delegate object. This object gets notified on certain events in scanning lifecycle. In this example we set it to `self`. The protocol which the delegate has to implement is [`MBBarcodeOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBBarcodeOverlayViewControllerDelegate.html) protocol. It is necessary to conform to that protocol. We will discuss more about protocols in [Advanced integration section](#advancedIntegration). You can use the following default implementation of the protocol to get you started.

```swift
func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBBarcodeOverlayViewController, state: MBRecognizerResultState) {

    // this is done on background thread
    // check for valid state
    if state == MBRecognizerResultState.valid {

        // first, pause scanning until we process all the results
        barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()

        DispatchQueue.main.async(execute: {() -> Void in
            // All UI interaction needs to be done on main thread
        })
    }
}

func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBBarcodeOverlayViewController) {
    // Your action on cancel 
}
```
    
```objective-c  
- (void)barcodeOverlayViewControllerDidFinishScanning:(MBBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBRecognizerResultState)state {
    
    // this is done on background thread
    // check for valid state
    if (state == MBRecognizerResultStateValid) {
        
        // first, pause scanning until we process all the results
        [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // All UI interaction needs to be done on main thread
        });
    }
}

- (void)barcodeOverlayViewControllerDidTapClose:(MBBarcodeOverlayViewController *)barcodeOverlayViewController {
    // Your action on cancel 
}
```

# <a name="advancedIntegration"></a> Advanced BlinkInput integration instructions
This section covers more advanced details of BlinkInput integration.

1. [First part](#uiCustomizations) will cover the possible customizations when using UI provided by the SDK.
2. [Second part](#recognizerRunnerViewController) will describe how to embed [`MBRecognizerRunnerViewController's delegates`](http://blinkinput.github.io/blinkinput-ios/Protocols.html) into your `UIViewController` with the goal of creating a custom UI for scanning, while still using camera management capabilites of the SDK.
3. [Third part](#directAPI) will describe how to use the [`MBRecognizerRunner`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerRunner.html) (Direct API) for recognition directly from `UIImage` without the need of camera or to recognize camera frames that are obtained by custom camera management.
4. [Fourth part](#availableRecognizers) will describe recognizer concept and available recognizers.

## <a name="uiCustomizations"></a> UI customizations of built-in `MBOverlayViewControllers` and `MBOverlaySubviews`

### <a name="builtInUIComponents"></a> Built-in overlay view controllers and overlay subviews

Within BlinkInput SDK there are several built-in overlay view controllers and scanning subview overlays that you can use to perform scanning.

#### `MBBarcodeOverlayViewController`

[`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html) is overlay view controller best suited for performing scanning of various barcodes. It has [`MBBarcodeOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBBarcodeOverlayViewControllerDelegate.html) delegate which can be used out of the box to perform scanning using the default UI.

## <a name="mbBarcodeOverlayViewcontroller"></a> Using `MBBarcodeOverlayViewController`

[`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html) is built-in overlay view controller which is best suiteed to use while scanning various barcodes. As you have seen in [Quick Start](#quickStart), [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html) has [`MBBarcodeOverlaySettings`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlaySettings.html). Here is an example how to use and initialize [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html):

Swift
```swift
/** Create your overlay view controller */
let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: barcodeSettings, recognizerCollection: recognizerCollection, delegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C
```objective-c
MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection: recognizerCollection delegate:self];
UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBBarcodeOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBBarcodeOverlayViewControllerDelegate.html) protocol.


## <a name="recognizerRunnerViewController"></a> Custom overlay view controller

Please check our pdf417-sample-Swift for custom implementation of overlay view controller.

Overlay View Controller is an abstract class for all overlay views.

It's responsibility is to provide meaningful and useful interface for the user to interact with.
 
Typical actions which need to be allowed to the user are:

- intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
- a way to cancel the scanning, typically with a "cancel" or "back" button
- a way to power on and off the light (i.e. "torch") button
 
BlinkInput SDK always provides it's own default implementation of the Overlay View Controller for every specific use. Your implementation should closely mimic the default implementation as it's the result of thorough testing with end users. Also, it closely matches the underlying scanning technology. 

For example, the scanning technology usually gives results very fast after the user places the device's camera in the expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user. The majority of time the user spends on positioning the device's camera correctly. That's just an example which demonstrates careful decision making behind default camera overlay view.

### 1. Initialization
 
To use your custom overlay with MicroBlink's camera view, you must first subclass [`MBCustomOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBCustomOverlayViewController.html) and implement the overlay behaviour conforming wanted protocols.

### 2. Protocols

There are five [`MBRecognizerRunnerViewController`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBRecognizerRunnerViewController.html) protocols and one overlay protocol [`MBOverlayViewControllerInterface`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBOverlayViewControllerInterface.html).

Five `RecognizerRunnerView` protocols are:
- [`MBScanningRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBScanningRecognizerRunnerViewControllerDelegate.html)
- [`MBDetectionRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBDetectionRecognizerRunnerViewControllerDelegate.html)
- [`MBOcrRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBOcrRecognizerRunnerViewControllerDelegate.html)
- [`MBDebugRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBDebugRecognizerRunnerViewControllerDelegate.html)
- [`MBRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBRecognizerRunnerViewControllerDelegate.html)

In `viewDidLoad`, other protocol conformation can be done and it's done on `recognizerRunnerViewController` property of [`MBOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBOverlayViewController.html), for example:

Swift and Objective-C
```swift
self.scanningRecognizerRunnerViewControllerDelegate = self;
```

### 3. Overlay subviews
Developer needs to know which subivew is needed for custom view controller. If you want to use built-in implementation we recommend to use [`MBModernViewfinderOverlaySubview`](http://blinkinput.github.io/blinkinput-ios/Classes/MBModernViewfinderOverlaySubview.html). In can be initialized in `viewDidLoad` method:

Swift
```swift
viewfinderSubview = MBModernViewfinderOverlaySubview()
viewfinderSubview.moveable = true
view.addSubview(viewfinderSubview)
```
Objective-C
```objective-c
self.viewfinderSubview = [[MBModernViewfinderOverlaySubview alloc] init];
self.viewfinderSubview.delegate = self.overlaySubviewsDelegate;
self.viewfinderSubview.moveable = YES;
[self.view addSubview:self.viewfinderSubview];
```

### 4. Initialization
In [Quick Start](#quickStart) guide it is shown how to use [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBRecognizerRunnerViewController.html). You can now swap [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBRecognizerRunnerViewController.html) with `CustomOverlayViewController`

Swift
```swift
let recognizerRunnerViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: CustomOverlayViewController)
```

Objective-C
```objective-c
UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:CustomOverlayViewController];
```


## <a name="directAPI"></a> Direct processing API

This guide will in short present you how to process UIImage objects with PDF417.mobi SDK, without starting the camera video capture.

With this feature you can solve various use cases like:
	- recognizing text on images in Camera roll
	- taking full resolution photo and sending it to processing
	- scanning barcodes on images in e-mail etc.

DirectAPI-sample demo app here will present UIImagePickerController for taking full resolution photos, and then process it with MicroBlink SDK to get scanning results using Direct processing API.

Direct processing API is handled with [`MBRecognizerRunner`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerRunner.html). That is a class that handles processing of images. It also has protocols as [`MBRecognizerRunnerViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerRunnerViewController.html).
Developer can choose which protocol to conform:

- [`MBScanningRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBScanningRecognizerRunnerDelegate.html)
- [`MBDetectionRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBDetectionRecognizerRunnerDelegate.html)
- [`MBDebugRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBDebugRecognizerRunnerDelegate.html)
- [`MBOcrRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBOcrRecognizerRunnerDelegate.html)

In example, we are conforming to [`MBScanningRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBScanningRecognizerRunnerDelegate.html) protocol.

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Swift
```swift
func setupRecognizerRunner() {
    var recognizers = [MBRecognizer]()
    pdf417Recognizer = MBPdf417Recognizer()
    recognizers.append(pdf417Recognizer!)
    let recognizerCollection = MBRecognizerCollection(recognizers: recognizers)
    recognizerRunner = MBRecognizerRunner(recognizerCollection: recognizerCollection)
    recognizerRunner?.scanningRecognizerRunnerDelegate = self
}

func processImageRunner(_ originalImage: UIImage) {
    var image: MBImage? = nil
    if let anImage = originalImage {
        image = MBImage(uiImage: anImage)
    }
    image?.cameraFrame = true
    image?.orientation = MBProcessingOrientation.left
    let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample-swift")
    _serialQueue.async(execute: {() -> Void in
        self.recognizerRunner?.processImage(image!)
    })
}

func recognizerRunner(_ recognizerRunner: MBRecognizerRunner, didFinishScanningWith state: MBRecognizerResultState) {
    if blinkInputRecognizer.result.resultState == MBRecognizerResultStateValid {
        // Handle result
    }
}
```

Objective-C
```objective-c
- (void)setupRecognizerRunner {
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
    
    self.blinkInputRecognizer = [[MBBlinkInputRecognizer alloc] init];
    
    [recognizers addObject:self.blinkInputRecognizer];
    
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

#pragma mark - MBScanningRecognizerRunnerDelegate
- (void)recognizerRunner:(nonnull MBRecognizerRunner *)recognizerRunner didFinishScanningWithState:(MBRecognizerResultState)state {
    if (self.blinkInputRecognizer.result.resultState == MBRecognizerResultStateValid) {
        // Handle result
    }
}
```

Now you've seen how to implement the Direct processing API.

In essence, this API consists of two steps:

- Initialization of the scanner.
- Call of processImage: method for each UIImage or CMSampleBufferRef you have.


# <a name="availableRecognizers"></a> `MBRecognizer` and available recognizers

## <a name="recognizerConcept"></a> The `MBRecognizer` concept

The [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) is the basic unit of processing within the SDK. Its main purpose is to process the image and extract meaningful information from it. As you will see [later](#recognizerList), the SDK has lots of different [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects that have various purposes.

Each [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) has a [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) object, which contains the data that was extracted from the image. The [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) object is a member of corresponding [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object its lifetime is bound to the lifetime of its parent [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object. If you need your `MBRecognizerRecognizer` object to outlive its parent [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object, you must make a copy of it by calling its method `copy`.

While [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object works, it changes its internal state and its result. The [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) always starts in `Empty` state. When corresponding [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object performs the recognition of given image, its [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) can either stay in `Empty` state (in case [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html)failed to perform recognition), move to `Uncertain` state (in case [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) performed the recognition, but not all mandatory information was extracted) or move to `Valid` state (in case [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) performed recognition and all mandatory information was successfully extracted from the image).

As soon as one [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) within [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html) given to `MBRecognizerRunner` or `MBRecognizerRunnerViewController` changes to `Valid` state, the `onScanningFinished` callback will be invoked on same thread that performs the background processing and you will have the opportunity to inspect each of your [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects' [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) to see which one has moved to `Valid` state.

As soon as `onScanningFinished` method ends, the `MBRecognizerRunnerViewController` will continue processing new camera frames with same [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects, unless `paused`. Continuation of processing or `reset` recognition will modify or reset all [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects's [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html). When using built-in activities, as soon as `onScanningFinished` is invoked, built-in activity pauses the `MBRecognizerRunnerViewController` and starts finishing the activity, while saving the [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html) with active [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html).

## <a name="recognizerBCollection"></a> `MBRecognizerCollection` concept

The [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html) is is wrapper around [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects that has array of [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects that can be used to give [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects to `MBRecognizerRunner` or `MBRecognizerRunnerViewController` for processing.

The [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html) is always constructed with array `[[MBRecognizerCollection alloc] initWithRecognizers:recognizers]` of [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects that need to be prepared for recognition (i.e. their properties must be tweaked already). 

The [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html) manages a chain of [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects within the recognition process. When a new image arrives, it is processed by the first [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) in chain, then by the second and so on, iterating until a [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) changes its state to `Valid` or all of the [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects in chain were invoked (none getting a `Valid` result state).

You cannot change the order of the [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects within the chain - no matter the order in which you give [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects to [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html), they are internally ordered in a way that provides best possible performance and accuracy. Also, in order for SDK to be able to order [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects in recognition chain in a best way possible, it is not allowed to have multiple instances of [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects of the same type within the chain. Attempting to do so will crash your application.

## <a name="recognizerList"></a> List of available recognizers

This section will give a list of all [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) objects that are available within PDF417.mobi SDK, their purpose and recommendations how they should be used to get best performance and user experience.

### <a name="frameGrabberRecognizer"></a> Frame Grabber Recognizer

The [`MBFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBFrameGrabberRecognizer.html) is the simplest recognizer in SDK, as it does not perform any processing on the given image, instead it just returns that image back to its `onFrameAvailable`. Its result never changes state from empty.

This recognizer is best for easy capturing of camera frames with `MBRecognizerRunnerViewController`. Note that [`MBImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBImage.html) sent to `onFrameAvailable` are temporary and their internal buffers all valid only until the `onFrameAvailable` method is executing - as soon as method ends, all internal buffers of [`MBImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBImage.html) object are disposed. If you need to store [`MBImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBImage.html) object for later use, you must create a copy of it by calling `copy`.

### <a name="successFrameGrabberRecognizer"></a> Success Frame Grabber Recognizer

The [`MBSuccessFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBSuccessFrameGrabberRecognizer.html) is a special `MBecognizer` that wraps some other [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) and impersonates it while processing the image. However, when the [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) being impersonated changes its [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) into `Valid` state, the [`MBSuccessFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBSuccessFrameGrabberRecognizer.html) captures the image and saves it into its own [`MBSuccessFrameGrabberRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBSuccessFrameGrabberRecognizerResult.html) object.

Since [`MBSuccessFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBSuccessFrameGrabberRecognizer.html)  impersonates its slave [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object, it is not possible to give both concrete [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object and `MBSuccessFrameGrabberRecognizer` that wraps it to same `MBRecognizerCollection` - doing so will have the same result as if you have given two instances of same [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) type to the [`MBRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerCollection.html) - it will crash your application.

This recognizer is best for use cases when you need to capture the exact image that was being processed by some other [`MBRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizer.html) object at the time its [`MBRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRecognizerResult.html) became `Valid`. When that happens, `MBSuccessFrameGrabberRecognizer's` `MBSuccessFrameGrabberRecognizerResult` will also become `Valid` and will contain described image.

### <a name="pdf417Recognizer"></a> PDF417 recognizer

The [`MBPdf417Recognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBPdf417Recognizer.html) is recognizer specialised for scanning [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417). This recognizer can recognize only PDF417 2D barcodes - for recognition of other barcodes, please refer to [BarcodeRecognizer](#barcodeRecognizer).

This recognizer can be used in any overlay view controller, but it works best with the [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.

### <a name="barcodeRecognizer"></a> Barcode recognizer

The [`MBBarcodeRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeRecognizer.html) is recognizer specialised for scanning various types of barcodes. This recognizer should be your first choice when scanning barcodes as it supports lots of barcode symbologies, including the [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417), thus making [PDF417 recognizer](#pdf417Recognizer) possibly redundant, which was kept only for its simplicity.

You can enable multiple barcode symbologies within this recognizer, however keep in mind that enabling more barcode symbologies affect scanning performance - the more barcode symbologies are enabled, the slower the overall recognition performance. Also, keep in mind that some simple barcode symbologies that lack proper redundancy, such as [Code 39](https://en.wikipedia.org/wiki/Code_39), can be recognized within more complex barcodes, especially 2D barcodes, like [PDF417](https://en.wikipedia.org/wiki/PDF417).

This recognizer can be used in any overlay view controller, but it works best with the [`MBBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.

### <a name="blinkInputRecognizer"></a> BlinkInput recognizer

The [`MBBlinkInputRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBBlinkInputRecognizer.html) is generic OCR recognizer used for scanning segments which enables specifying `MBProcessors` that will be used for scanning. Most commonly used `MBProcessor` within this recognizer is [`MBParserGroupProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBParserGroupProcessor.html)) that activates all `MBParsers` in the group to extract data of interest from the OCR result.

This recognizer can be used in any context. It is used internally in the implementation of the provided [`MBFieldByFieldOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBFieldByFieldOverlayViewController.html).

`MBProcessors` are explained in [The Processor concept](#processorConcept) section and you can find more about `MBParsers` in [The Parser concept](#parserConcept) section.

### <a name="detectorRecognizer"></a> Detector recognizer

The [`MBDetectorRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDetectorRecognizer.html) is recognizer for scanning generic documents using custom `MBDetector`. You can find more about `Detector` in [The Detector concept](#detectorConcept) section. `MBDetectorRecognizer` can be used simply for document detection and obtaining its image. The more interesting use case is data extraction from the custom document type. `MBDetectorRecognizer` performs document detection and can be configured to extract fields of interest from the scanned document by using **Templating API**. You can find more about Templating API in [this](#detectorTemplating) section.  

# <a name="fieldScan"></a> `Field by field` scanning feature

[`Field by field`](#fieldByFieldFeature) scanning feature is designed for scanning small text fields which are called scan elements. For each scan element, specific [`MBParser`](#parserConcept) that will extract structured data of interest from the OCR result is defined. Focusing on the small text fields which are scanned one by one enables implementing support for the **free-form documents** because field detection is not required. The user is responsible for positioning the field of interest inside the scanning window and the scanning process guides him. When implementing support for the custom document, only fields of interest has to be defined.

[`Field by field`](#fieldByFieldFeature) approaches are described in the following sections.

## <a name="fieldByFieldFeature"></a> `Field by field` feature

`Field by field` feature is designed for scanning small text fields in the predefined order by using [`MBFieldByFieldViewController`](#fieldByFieldUiComponent).

To start with Field by Field feature all you need to do is to initialize MBFieldByFieldOverlayViewController and conform to [`MBFieldByFieldOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBFieldByFieldOverlayViewControllerDelegate.html) (this example follows our FieldByField-sample-Swift project):

Swift
```swift
    // Create MBFieldByFieldOverlaySettings
    let settings = MBFieldByFieldOverlaySettings(scanElements: MBGenericPreset.getPreset()!)
    
    // Create field by field VC
    let fieldByFieldVC = MBFieldByFieldOverlayViewController(settings: settings, delegate: self)
    
    // Create scanning VC
    let recognizerRunnerViewController: (UIViewController & MBRecognizerRunnerViewController)? = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: fieldByFieldVC)
    
    // Present VC
    self.present(recognizerRunnerViewController!, animated: true, completion: nil)


    func field(_ fieldByFieldOverlayViewController: MBFieldByFieldOverlayViewController, didFinishScanningWith scanElements: [MBScanElement]) {
    	// Whatever you want to do with results
    }
```

Objective-C
```objective-c
	// Create MBFieldByFieldOverlaySettings
	MBFieldByFieldOverlaySettings *settings = [[MBFieldByFieldOverlaySettings alloc] initWithScanElements: [MBGenericPreset getPreset] initWithSettings: settings, delegate: self];

	// Create field by field VC
	MBFieldByFieldOverlayViewController *fieldByFieldOverlayViewController =  [[MBFieldByFieldOverlayViewController alloc] initWithSettings:settings delegate: self];

	// Create scanning VC
	UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:fieldByFieldOverlayViewController];

	/ Present VC
	[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];

	- (void)fieldByFieldOverlayViewController:(MBFieldByFieldOverlayViewController *)fieldByFieldOverlayViewController didFinishScanningWithElements:(NSArray<MBScanElement *> *)scanElements {
		// Whatever you want to do with results
	}
```


# <a name="processorsAndParsers"></a> `MBProcessor` and `MBParser`

The `MBProcessors` and `MBParsers` are standard processing units within *BlinkInput* SDK used for data extraction from the input images. Unlike the [`MBRecognizer`](#recognizerConcept), `MBProcessor` and `MBParser` are not stand-alone processing units. `MBProcessor` is always used within `MBRecognizer` and `MBParser` is used within appropriate `MBProcessor` to extract data from the OCR result.

## <a name="processorConcept"></a> The `MBProcessor` concept

`MBProcessor` is a processing unit used within some `Recognizer` which supports processors. It process the input image prepared by the enclosing `Recognizer` in the way that is characteristic to the implementation of the concrete `MBProcessor`.

`MBProcessor` architecture is similar to `MBRecognizer` architecture described in [The Recognizer concept](#recognizerConcept) section. Each instance also has associated inner `MBRecognizerResult` object whose lifetime is bound to the lifetime of its parent `MBProcessor` object and it is updated while `MBProcessor` works. If you need your `MBRecognizerResult` object to outlive its parent `MBProcessor` object, you must make a copy of it by calling its method `copy`.

It also has its internal state and while it is in the *working state* during recognition process, it is not allowed to tweak `MBProcessor` object's properties.

To support common use cases, there are several different `MBProcessor` implementations available. They are listed in the next section.

## <a name="processorList"></a> List of available processors

This section will give a list of `MBProcessor` types that are available within *BlinkInput* SDK and their purpose.

### <a name="imageReturnProcessor"></a> Image Return Processor

The [`MBImageReturnProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBImageReturnProcessor.html) is used for obtaining input images. It simply saves the input image and makes it available after the scanning is done.

The appearance of the input image depends on the context in which `MBImageReturnProcessor` is used. For example, when it is used within [`MBBlinkInputRecognizer`](#blinkInputRecognizer), simply the raw image of the scanning region is processed. When it is used within the [`Templating API`](#detectorTemplating), input image is dewarped (cropped and rotated).
 
The image is returned as the raw [`MBImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBImage.html) type. Also, processor can be configured to [encode saved image to JPEG](http://blinkinput.github.io/blinkinput-ios/Classes/MBImageReturnProcessor.html).

### <a name="parserGroupProcessor"></a> Parser Group Processor


The [`MBParserGroupProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBParserGroupProcessor.html) is the type of the processor that performs the OCR (*Optical Character Recognition*) on the input image and lets all the parsers within the group to extract data from the OCR result. The concept of `MBParser` is described in [the next](#parserConcept) section.

Before performing the OCR, the best possible OCR engine options are calculated by combining engine options needed by each `MBParser` from the group. For example, if one parser expects and produces result from uppercase characters and other parser extracts data from digits, both uppercase characters and digits must be added to the list of allowed characters that can appear in the OCR result. This is a simplified explanation because OCR engine options contain many parameters which are combined by the `MBParserGroupProcessor`.

Because of that, if multiple parsers and multiple parser group processors are used during the scan, it is very important to group parsers carefully.

Let's see this on an example: assume that we have two parsers at our disposal: `MBAmountParser` and `MBEmailParser`. `MBAmountParser` knows how to extract amount's from OCR result and requires from OCR only to recognize digits, periods and commas and ignore letters. On the other hand, `MBEmailParser` knows how to extract e-mails from OCR result and requires from OCR to recognize letters, digits, '@' characters and periods, but not commas. 

If we put both `MBAmountParser` and `MBEmailParser` into the same `MBParserGroupProcessor`, the merged OCR engine settings will require recognition of all letters, all digits, '@' character, both period and comma. Such OCR result will contain all characters for `MBEmailParser` to properly parse e-mail, but might confuse `MBAmountParser` if OCR misclassifies some characters into digits.

If we put `MBAmountParser` in one `MBParserGroupProcessor` and `MBEmailParser` in another `MBParserGroupProcessor`, OCR will be performed for each parser group independently, thus preventing the `MBAmountParser` confusion, but two OCR passes of the image will be performed, which can have a performance impact.

`MBParserGroupProcessor` is most commonly used `MBProcessor`. It is used whenever the OCR is needed. After the OCR is performed and all parsers are run, parsed results can be obtained through parser objects that are enclosed in the group. `MBParserGroupProcessor` instance also has associated inner `MBParserGroupProcessorResult` whose state is updated during processing and its property [`ocrLayout`](http://blinkinput.github.io/blinkinput-ios/Classes/MBParserGroupProcessor.html) can be used to obtain the raw [`MBOcrLayout`](http://blinkinput.github.io/blinkinput-ios/Classes/MBOcrLayout.html) that was used for parsing data.

Take note that `MBOcrLayout` is available only if it is allowed by the *BlinkInput* SDK license key. `MBOcrLayout` structure contains information about all recognized characters and their positions on the image. To prevent someone to abuse that, obtaining of the `MBOcrLayout` structure is allowed only by the premium license keys.

## <a name="parserConcept"></a> The `MBParser` concept

`MBParser` is a class of objects that are used to extract structured data from the raw OCR result. It must be used within `MBParserGroupProcessor` which is responsible for performing the OCR, so `MBParser` is not stand-alone processing unit.

Like [`MBRecognizer`](#recognizerConcept) and all other processing units, each `MBParser` instance has associated inner `MBRecognizerResult` object whose lifetime is bound to the lifetime of its parent `MBParser` object and it is updated while `MBParser` works. When parsing is done `MBParserResult` can be used for obtaining extracted data. If you need your `MBParserResult` object to outlive its parent `MBParser` object, you must make a copy of it by calling its method `copy`.

It also has its internal state and while it is in the *working state* during recognition process, it is not allowed to tweak `MBParser` object's properties.

There are a lot of different `MBParsers` for extracting most common fields which appear on various documents. Also, most of them can be adjusted for specific use cases. For all other custom data fields, there is `RegexParser` available which can be configured with the arbitrary regular expression.

## <a name="parserList"></a> List of available parsers

### <a name="amountParser"></a> Amount Parser

[`MBAmountParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBAmountParser.html) is used for extracting amounts from the OCR result.

### <a name="dateParser"></a> Date Parser

[`MBDateParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDateParser.html) is used for extracting dates in various formats from the OCR result.

### <a name="emailParser"></a> Email Parser

[`MBEmailParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBEmailParser.html) is used for extracting e-mail addresses from the OCR result.

### <a name="ibanParser"></a> IBAN Parser

[`MBIbanParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIbanParser.html) is used for extracting IBAN (*International Bank Account Number*) from the OCR result.

### <a name="licensePlatesParser"></a> License Plates Parser

[`MBLicensePlatesParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBLicensePlatesParser.html) is used for extracting license plate content from the OCR result.

### <a name="rawParser"></a> Raw Parser

[`MBRawParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRawParser.html) is used for obtaining string version of raw OCR result, without performing any smart parsing operations.

### <a name="regexParser"></a> Regex Parser

[`MBRegexParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBRegexParser.html) is used for extracting OCR result content which is in accordance with the given regular expression. Regular expression parsing is not performed with java's regex engine. Instead, it is performed with custom regular expression engine.

### <a name="topUpParser"></a> TopUp Parser

[`MBTopUpParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBTopUpParser.html) is used for extracting TopUp (mobile phone coupon) codes from the OCR result. There exists [`TopUpPreset`](http://blinkinput.github.io/blinkinput-ios/Enums/MBTopUpPreset.html) enum with presets for most common vendors. Method `- (void)setTopUpPreset:(MBTopUpPreset)topUpPreset` can be used to configure parser to only return codes with the appropriate format defined by the used preset. 

### <a name="vinParser"></a> VIN (*Vehicle Identification Number*) Parser

[`MBVinParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBVinParser.html) is used for extracting VIN (*Vehicle Identification Number*) from the OCR result.
# <a name="detectorTemplating"></a> Scanning generic documents with Templating API

This section discusses the setting up of `MBDetectorRecognizer` for scanning templated documents. Please check `Templating-sample` sample app for source code examples.

Templated document is any document which is defined by its template. Template contains the information about how the document should be detected, i.e. found on the camera scene and information about which part of the document contains which useful information.

## Defining how document should be detected

Before performing OCR of the document, _BlinkInput_ first needs to find its location on a camera scene. In order to perform detection, you need to define [MBDetector](#detectorConcept). 

You have to set concrete `MBDetector` when instantiating the `MBDetectorRecognizer` as a parameter to its constructor.

You can find out more information about detectors that can be used in section [List of available detectors](#detectorList). The most commonly used detector is [`MBDocumentDetector`](#documentDetector).

## Defining how fields of interest should be extracted

`MBDetector` produces its result which contains document location. After the document has been detected, all further processing is done on the detected part of the input image.

There may be one or more variants of the same document type, for example for some document there may be old and new version and both of them must be supported. Because of that, for implementing support for each document, one or multiple templating classes are used. `MBTemplatingClass` is described in [The Templating Class component](#templatingClass) section.

`MBTemplatingClass` holds all needed information and components for processing its class of documents. Templating classes are processed in chain, one by one. On first class for which the data is successfully extracted, the chain is terminated and recognition results are returned. For each input image processing is done in the following way:

1. Classification `MBProcessorGroups` are run on the defined locations to extract data. `MBProcessorGroup` is used to define the location of interest on the detected document and `MBProcessors` that will extract data from that location. You can find more about `MBProcessorGroup` in the [next section](#processorGroup).

2. `MBTemplatingClassifier` is run with the data extracted by the classification processor groups to decide whether the currently scanned document belongs to the current class or not. Its [classify](http://blinkinput.github.io/blinkinput-ios/Protocols/MBTemplatingClassifier.html) method  simply returns `YES/true` or `NO/false`. If the classifier returns `NO/false`, recognition is moved to the next class in the chain, if it exists. You can find more about `MBTemplatingClassifier` in [this](#implementingTemplatingClassifier) section.

3. If the `MBTemplatingClassifier` has decided that currently scanned document belongs to the current class, non-classification `MBProcessorGroups` are run to extract other fields of interest.

### <a name="processorGroup"></a> The `MBProcessorGroup` component

In templating API [`MBProcessorGroup`](http://blinkinput.github.io/blinkinput-ios/Classes/MBProcessorGroup.html) is used to define the location of the field of interest on the detected document and how that location should be processed by setting following parameters in its constructor:

1. Location coordinates relative to document detection which are passed as [`Rectangle`] object.

2. `MBDewarpPolicy` which determines the resulting image chunk for processing. You can find a description of each `MBDewarpPolicy`, its purpose and recommendations when it should be used to get the best results in [List of available dewarp policies](#dewarpPolicyList) section.

3. Collection of processors that will be executed on the prepared chunk of the image for current document location. You can find more information about processors in [The Processor concept](#processorConcept) section.

### <a name="dewarpPolicyList"></a> List of available dewarp policies

Concrete `MBDewarpPolicy` defines how specific location of interest should be dewarped (cropped and rotated). It determines the height and width of the resulting dewarped image in pixels. Here is the list of available dewarp policies with linked doc for more information:

- [`MBFixedDewarpPolicy`](http://blinkinput.github.io/blinkinput-ios/Classes/MBFixedDewarpPolicy.html)
    - defines the exact height of the dewarped image in pixels
    - **usually the best policy for processor groups that use a legacy OCR engine**

- [`MBDPIBasedDewarpPolicy`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDPIBasedDewarpPolicy.html):
    - defines the desired DPI (*Dots Per Inch*)
    - the height of the dewarped image will be calculated based on the actual physical size of the document provided by the used detector and chosen DPI
    - **usually the best policy for processor groups that prepare location's raw image for output**
 
- [`MBNoUpScalingDewarpPolicy`](http://blinkinput.github.io/blinkinput-ios/Classes/MBNoUpScalingDewarpPolicy.html): 
    - defines the maximal allowed height of the dewarped image in pixels
    - the height of the dewarped image will be calculated in a way that no part of the image will be up-scaled
    - if the height of the resulting image is larger than maximal allowed, then the maximal allowed height will be used as actual height, which effectively scales down the image
    - **usually the best policy for processors that use neural networks, for example,  DEEP OCR, hologram detection or NN-based classification**

### <a name="templatingClass"></a> The `MBTemplatingClass` component

[`MBTemplatingClass`](http://blinkinput.github.io/blinkinput-ios/Classes/MBTemplatingClass.html) enables implementing support for a specific class of documents that should be scanned with templating API. Final implementation of the templating recognizer consists of one or more templating classes, one class for each version of the document.

`MBTemplatingClass` contains two collections of `MBProcessorGroups` and a `MBTemplatingClassifier`.

The two collections of processor groups within `MBTemplatingClass` are:

1. The classification processor groups which are set by using the [`- (void)setClassificationProcessorGroups:(nonnull NSArray<__kindof MBProcessorGroup *> *)processorGroups`] method. `MBProcessorGroups` from this collection will be executed before classification, which means that they are always executed when processing comes to this class.

2. The non-classification processor groups which are set by using the [`- (void)setNonClassificationProcessorGroups:(nonnull NSArray<__kindof MBProcessorGroup *> *)processorGroups`]method. `MBProcessorGroups` from this collection will be executed after classification if the classification has been positive.

A component which decides whether the scanned document belongs to the current class is [`MBTemplatingClass`](http://blinkinput.github.io/blinkinput-ios/Classes/MBTemplatingClass.html). It can be set by using the `- (void)setTemplatingClassifier:(nullable id<MBTemplatingClassifier>)templatingClassifier` method. If it is not set, non-classification processor groups will not be executed. Instructions for implementing the `MBTemplatingClassifier` are given in the [next section](#implementingTemplatingClassifier).

### <a name="implementingTemplatingClassifier"></a> Implementing the `MBTemplatingClassifier`

Each concrete templating classifier implements the [`MBTemplatingClassifier`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBTemplatingClassifier.html) interface, which requires to implement its `classify` method that is invoked while evaluating associated `MBTemplatingClass`.

Classification decision should be made based on the processing result which is returned by one or more processing units contained in the collection of the classification processor groups. As described in [The ProcessorGroup component](#processorGroup) section, each processor group contains one or more `MBProcessors`. [There are different `MBProcessors`](#processorList) which may enclose smaller processing units, for example, [`MBParserGroupProcessor`](#parserGroupProcessor) maintains the group of [`MBParsers`](#parserConcept). Result from each of the processing units in that hierarchy can be used for classification. In most cases `MBParser` result is used to determine whether some data in the expected format exists on the specified location.

To be able to retrieve results from the various processing units that are needed for classification, their instances must be available when `classify` method is called.

## Obtaining recognition results

When recognition is done, results can be obtained through processing units instances, such as: `MBProcessors`, `MBParsers`, etc. which are used for configuring the `MBTemplatingRecognizer` and later for processing the input image.

# <a name="detectorConcept"></a> The `MBDetector` concept

[`MBDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDetector.html) is a processing unit used within some `MBRecognizer` which supports detectors, such as [`MBDetectorRecognizer`](#detectorRecognizer). Concrete `MBDetector` knows how to find the certain object on the input image. `MBRecognizer` can use it to perform object detection prior to performing further recognition of detected object's contents.

`MBDetector` architecture is similar to `MBRecognizer` architecture described in [The Recognizer concept](#recognizerConcept) section. Each instance also has associated inner `MBRecognizerResult` object whose lifetime is bound to the lifetime of its parent `MBDetector` object and it is updated while `MBDetector` works. If you need your `MBRecognizerResult` object to outlive its parent `MBDetector` object, you must make a copy of it by calling its `copy` method.

It also has its internal state and while it is in the *working state* during recognition process, it is not allowed to tweak `MBDetector` object's properties.

When detection is performed on the input image, each `MBDetector` in its associated `MBDetectorResult` object holds the following information:

- [`MBDetectionCode`](http://blinkinput.github.io/blinkinput-ios/Enums/MBDetectionCode.html) that indicates the type of the detection.

- [`MBDetectionStatus`](http://blinkinput.github.io/blinkinput-ios/Enums/MBDetectionStatus.html) that represents the status of the detection.

- each concrete detector returns additional information specific to the detector type


To support common use cases, there are several different `MBDetector` implementations available. They are listed in the next section.

## <a name="detectorList"></a> List of available detectors

### <a name="documentDetector"></a> Document Detector

[`MBDocumentDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDocumentDetector.html) is used to detect card documents, cheques, A4-sized documents, receipts and much more.

It accepts one or more `MBDocumentSpecifications`. [`MBDocumentSpecification`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDocumentSpecification.html) represents a specification of the document that should be detected by using edge detection algorithm and predefined aspect ratio.

For the most commonly used document formats, there is a helper method  `+ (instancetype)createFromPreset:(MBDocumentSpecificationPreset)preset` which creates and initializes the document specification based on the given [`MBDocumentSpecificationPreset`](http://blinkinput.github.io/blinkinput-ios/Enums/MBDocumentSpecificationPreset.html).

For the list of all available configuration methods see [`MBDocumentDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDocumentDetector.html) doc, and for available result content see [`MBDocumentDetectorResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBDocumentDetectorResult.html) doc.


### <a name="mrtdDetector"></a> MRTD Detector

[`MBMrtdDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBMrtdDetector.html) is used to perform detection of *Machine Readable Travel Documents (MRTD)*.

Method `- (void)setMrtdSpecifications:(NSArray<__kindof MBMrtdSpecification *> *)mrtdSpecifications` can be used to define which MRTD documents should be detectable. It accepts the array of `MBMrtdSpecification`. [`MBMrtdSpecification`](http://blinkinput.github.io/blinkinput-ios/Classes/MBMrtdSpecification.html) represents specification of MRTD that should be detected. It can be created from the [`MBMrtdSpecificationPreset`](http://blinkinput.github.io/blinkinput-ios/Enums/MBMrtdSpecificationPreset.html) by using `+ (instancetype)createFromPreset:(MBMrtdSpecificationPreset)preset` method.

If `MBMrtdSpecifications` are not set, all supported MRTD formats will be detectable.

For the list of all available configuration methods see [`MBMrtdDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBMrtdDetector.html) doc, and for available result content see [`MBMrtdDetectorResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBMrtdDetectorResult.html) doc.

# <a name="troubleshoot"></a> Troubleshooting

## <a name="integrationTroubleshoot"></a> Integration problems

In case of problems with integration of the SDK, first make sure that you have tried integrating it into XCode by following [integration instructions](#quickStart).

If you have followed [XCode integration instructions](#quickStart) and are still having integration problems, please contact us at [help.microblink.com](http://help.microblink.com).

## <a name="sdkTroubleshoot"></a> SDK problems

In case of problems with using the SDK, you should do as follows:

### Licencing problems

If you are getting "invalid licence key" error or having other licence-related problems (e.g. some feature is not enabled that should be or there is a watermark on top of camera), first check the console. All licence-related problems are logged to error log so it is easy to determine what went wrong.

When you have determine what is the licence-relate problem or you simply do not understand the log, you should contact us [help.microblink.com](http://help.microblink.com). When contacting us, please make sure you provide following information:

* exact Bundle ID of your app (from your `info.plist` file)
* licence that is causing problems
* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK
* if unsure about the problem, you should also provide excerpt from console containing licence error

### Other problems

If you are having problems with scanning certain items, undesired behaviour on specific device(s), crashes inside PDF417.mobi SDK or anything unmentioned, please do as follows:
	
* Contact us at [help.microblink.com](http://help.microblink.com) describing your problem and provide following information:
	* log file obtained in previous step
	* high resolution scan/photo of the item that you are trying to scan
	* information about device that you are using
	* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK

## <a name="faq"></a> Frequently asked questions and known problems
Here is a list of frequently asked questions and solutions for them and also a list of known problems in the SDK and how to work around them.

#### <a name="featureNotSupportedByLicenseKey"></a> In demo everything worked, but after switching to production license I get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code as soon as I construct specific [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizer.html) object

Each license key contains information about which features are allowed to use and which are not. This `NSError` indicates that your production license does not allow using of specific `MBRecognizer` object. You should contact [support](http://help.microblink.com) to check if provided licence is OK and that it really contains all features that you have purchased.

#### <a name="invalidLicenseKey"></a> I get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code with trial license key

Whenever you construct any [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizer.html) object or, a check whether license allows using that object will be performed. If license is not set prior constructing that object, you will get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code. We recommend setting license as early as possible in your app.

#### <a name="undefinedSymbols"></a> Undefined Symbols on Architecture armv7

Make sure you link your app with iconv and Accelerate frameworks as shown in [Quick start](#quickStart). 
If you are using Cocoapods, please be sure that you've installed `git-lfs` prior to installing pods. If you are still getting this error, go to project folder and execute command `git-lfs pull`.

#### <a name="statefulRecognizer"></a> In my `didFinish` callback I have the result inside my `MBRecognizer`, but when scanning activity finishes, the result is gone

This usually happens when using [`MBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizerRunnerViewController.html) and forgetting to pause the [`MBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizerRunnerViewController.html) in your `didFinish` callback. Then, as soon as `didFinish` happens, the result is mutated or reset by additional processing that `MBRecognizer` performs in the time between end of your `didFinish` callback and actual finishing of the scanning activity. For more information about statefulness of the `MBRecognizer` objects, check [this section](#recognizerConcept).

#### <a name="unsupportedArchitecture"></a> Unsupported architectures when submitting app to App Store

Microblink.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures. 

Ideal solution is to add a build phase after embed frameworks build phase, which strips unused slices from embedded frameworks.

Build step is based on the one provided here: http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/

```shell
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```

# <a name="info"></a> Additional info

Complete API reference can be found [here](http://blinkinput.github.io/blinkinput-ios/docs/index.html). 

For any other questions, feel free to contact us at [help.microblink.com](http://help.microblink.com).
