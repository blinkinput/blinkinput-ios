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

- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Advanced BlinkInput integration instructions](#advanced-integration)
	- [Built-in overlay view controllers and overlay subviews](#ui-customizations)
		- [Using `MBIBarcodeOverlayViewController`](#using-pdf417-overlay-viewcontroller)
		- [Using `MBIFieldByFieldOverlayViewController`](#using-fieldbyfield-overlay-viewcontroller)
		- [Using `MBIDocumentCaptureOverlayViewController`](#using-documentcapture-overlay-viewcontroller)
		- [Custom overlay view controller](#using-custom-overlay-viewcontroller)
	- [Direct processing API](#direct-api-processing)
		- [Using Direct API for `NSString` recognition (parsing)](#direct-api-string-processing)
- [`MBIRecognizer` and available recognizers](#recognizer)
- [List of available recognizers](#available-recognizers)
	- [Frame Grabber Recognizer](#frame-grabber-recognizer)
	- [Success Frame Grabber Recognizer](#success-frame-grabber-recognizer)
	- [PDF417 recognizer](#pdf417-recognizer)
	- [Barcode recognizer](#barcode-recognizer)
	- [BlinkInput recognizer](#blinkinput-recognizer)
	- [Detector recognizer](#detector-recognizer)
	- [Document Capture recognizer](#document-capture-recognizer)
- [`MBIProcessor` and `MBIParser`](#processors-and-parsers)
	- [The `MBIProcessor` concept](#processor-concept)
		- [Image Return Processor](#image-processors)
		- [Parser Group Processor](#parser-group-processor)
	- [The `MBIParser` concept](#parser-concept)
		- [Amount Parser](#amount-parser)
		- [Date Parser](#date-parser)
		- [Email Parser](#email-parser)
		- [IBAN Parser](#iban-parser)
		- [License Plates Parser](#license-plate-parser)
		- [Raw Parser](#raw-parser)
		- [Regex Parser](#regex-parser)
		- [TopUp Parser](#topup-parser)
		- [VIN (*Vehicle Identification Number*) Parser](#vin-parser)
- [Scanning generic documents with Templating API](#templating-api)
	- [Defining how document should be detected](#defining-document-detection)
	- [Defining how fields of interest should be extracted](#defining-field-extraction)
		- [The `MBIProcessorGroup` component](#processor-group)
		- [List of available dewarp policies](#dewarp-policy-list)
		- [The `MBITemplatingClass` component](#templating-class)
		- [Implementing the `MBITemplatingClassifier`](#implementing-templating-classifier)
- [The `MBIDetector` concept](#detector-concept)
	- [List of available detectors](#detector-list)
		- [Document Detector](#document-detector)
		- [MRTD Detector](#mrtd-detector)
- [Localization](#localization)
- [Troubleshooting](#troubleshooting)
	- [Integration problems](#troubleshooting-integration-problems)
	- [SDK problems](#troubleshooting-sdk-problems)
		- [Licencing problems](#troubleshooting-licensing-problems)
		- [Other problems](#troubleshooting-other-problems)
	- [Frequently asked questions and known problems](#troubleshooting-faq)
- [Size Report](#size-report)
- [Additional info](#info)


# <a name="requirements"></a> Requirements

SDK package contains BlinkInput framework and one or more sample apps which demonstrate framework integration. The framework can be deployed in **iOS 9.0 or later**.

SDK performs significantly better when the images obtained from the camera are focused. Because of that, the SDK can have lower performance on iPad 2 and iPod Touch 4th gen devices, which [don't have camera with autofocus](http://www.adweek.com/socialtimes/ipad-2-rear-camera-has-tap-for-auto-exposure-not-auto-focus/12536). 
# <a name="quick-start"></a> Quick Start

## Getting started with BlinkInput SDK

This Quick Start guide will get you up and performing OCR scanning as quickly as possible. All steps described in this guide are required for the integration.

This guide sets up basic Raw OCR parsing and price parsing at the same time. It closely follows the BlinkOCR-sample app. We highly recommend you try to run the sample app. The sample app should compile and run on your device, and in the iOS Simulator.

The source code of the sample app can be used as the reference during the integration.

### 1. Initial integration steps

#### Using CocoaPods

- Since the libraries are stored on [Git Large File Storage](https://git-lfs.github.com), you need to install git-lfs by running these commands:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**
- **Note:** if you already did try adding SDK using cocoapods and it's not working, first install the git-lfs and then clear you cocoapods cache. This should be sufficient to force cocoapods to clone BlinkInput SDK, if it still doesn't work, try deinitializing your pods and installing them again.
- Project dependencies to be managed by CocoaPods are specified in a file called `Podfile`. Create this file in the same directory as your Xcode project (`.xcodeproj`) file.

- If you don't have podfile initialized run the following in your project directory.
```
pod init
```

- Copy and paste the following lines into the TextEdit window:

```ruby
platform :ios, '9.0'
target 'Your-App-Name' do
    pod 'PPBlinkOCR', '~> 5.0.0'
end
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


-[Download](https://github.com/BlinkInput/blinkinput-ios/releases) latest release (Download .zip or .tar.gz file starting with BlinkInput. DO NOT download Source Code as GitHub does not fully support Git LFS)

OR

Clone this git repository:

- Since the libraries are stored on [Git Large File Storage](https://git-lfs.github.com), you need to install git-lfs by running these commands:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**

- To clone, run the following shell command:

```shell
git clone git@github.com:BlinkInput/blinkinput-ios.git
```

- Copy BlinkInput.xcframework to your project folder.

- In your Xcode project, open the Project navigator. Drag the BlinkInput.xcframework file to your project, ideally in the Frameworks group, together with other frameworks you're using. When asked, choose "Create groups", instead of the "Create folder references" option.

![Adding BlinkInput.xcframework to your project](https://user-images.githubusercontent.com/1635933/89505694-535a1680-d7ca-11ea-8c65-678f158acae9.png)

- Since BlinkInput.xcframework is a dynamic framework, you also need to add it to embedded binaries section in General settings of your target.

![Adding BlinkInput.xcframework to embedded binaries](https://user-images.githubusercontent.com/1635933/89793425-238e7400-db26-11ea-9556-6eedeb6dcc95.png)

- Include the additional frameworks and libraries into your project in the "Linked frameworks and libraries" section of your target settings.

    - libc++.tbd
    - libiconv.tbd
    - libz.tbd

![Adding Apple frameworks to your project](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/02%20-%20Add%20Libraries.png)

### 2. Referencing header file

In files in which you want to use scanning functionality place import directive.

Swift

```swift
import BlinkInput
```

Objective-C

```objective-c
#import <BlinkInput/BlinkInput.h>
```

### 3. Initiating the scanning process

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Also, for initialization purposes, the ViewController which initiates the scan have private properties for [`MBIRawParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRawParser.html), [`MBIParserGroupProcessor`](http://blinkinput.github.io/blinkinput-ios//Classes/MBIParserGroupProcessor.html) and [`MBIBlinkInputRecognizer`](http://blinkinput.github.io/blinkinput-ios//Classes/MBIBlinkInputRecognizer.html), so we know how to obtain result.

Swift

```swift
class ViewController: UIViewController, MBIDocumentOverlayViewControllerDelegate  {

    var rawParser: MBIRawParser?
    var parserGroupProcessor: MBIParserGroupProcessor?
    var blinkInputRecognizer: MBIBlinkInputRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapScan(_ sender: AnyObject) {

        let settings = MBIDocumentOverlaySettings()
        rawParser = MBIRawParser()
        parserGroupProcessor = MBIParserGroupProcessor(parsers: [rawParser!])
        blinkInputRecognizer = MBIBlinkInputRecognizer(processors: [parserGroupProcessor!])

        let recognizerList = [self.blinkInputRecognizer!]
        let recognizerCollection = MBIRecognizerCollection(recognizers: recognizerList)

        /** Create your overlay view controller */
        let documentOverlayViewController = MBIDocumentOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)

        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunnerViewController: UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentOverlayViewController)

        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}
```

Objective-C

```objective-c
@interface ViewController () <MBIDocumentOverlayViewControllerDelegate>

@property (nonatomic, strong) MBIRawParser *rawParser;
@property (nonatomic, strong) MBIParserGroupProcessor *parserGroupProcessor;
@property (nonatomic, strong) MBIBlinkInputRecognizer *blinkInputRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)didTapScan:(id)sender {

    MBIDocumentOverlaySettings* settings = [[MBIDocumentOverlaySettings alloc] init];

    self.rawParser = [[MBIRawParser alloc] init];
    self.parserGroupProcessor = [[MBIParserGroupProcessor alloc] initWithParsers:@[self.rawParser]];
    self.blinkInputRecognizer = [[MBIBlinkInputRecognizer alloc] initWithProcessors:@[self.parserGroupProcessor]];

    /** Create recognizer collection */
    MBIRecognizerCollection *recognizerCollection = [[MBIRecognizerCollection alloc] initWithRecognizers:@[self.blinkInputRecognizer]];

    MBIDocumentOverlayViewController *overlayVC = [[MBIDocumentOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];
    UIViewController<MBIRecognizerRunnerViewController>* recognizerRunnerViewController = [MBIViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];

}

@end
```

### 4. License key

A valid license key is required to initalize scanning. You can generate a free trial license key, after you register, at [Microblink developer dashboard](https://microblink.com/login).

You can include the license key in your app by passing a string or a file with license key.
**Note** that you need to set the license key before intializing scanning. Ideally in `AppDelegate` or `viewDidLoad` before initializing any recognizers.

#### License key as string
You can pass the license key as a string, the following way:

Swift

```swift
MBIMicroblinkSDK.shared().setLicenseKey("LICENSE-KEY")
```

Objective-C

```objective-c
[[MBIMicroblinkSDK sharedInstance] setLicenseKey:@"LICENSE-KEY"];
```

#### License key as file
Or you can include the license key, with the code below. Please make sure that the file that contains the license key is included in your project and is copied during **Copy Bundle Resources** build phase.

Swift

```swift
MBIMicroblinkSDK.shared().setLicenseResource("license-key-file", withExtension: "txt", inSubdirectory: "directory-to-license-key", for: Bundle.main)
```

Objective-C

```objective-c
[[MBIMicroblinkSDK sharedInstance] setLicenseResource:@"license-key-file" withExtension:@"txt" inSubdirectory:@"" forBundle:[NSBundle mainBundle]];
```

If the licence is invalid or expired then the methods above will throw an **exception**.

### 5. Registering for scanning events

In the previous step, you instantiated [`MBIDocumentOverlayViewController`](http://blinkinput.github.io/blinkinput-ios//Classes/MBIDocumentOverlayViewController.html) object with a delegate object. This object gets notified on certain events in scanning lifecycle. In this example we set it to `self`. The protocol which the delegate has to implement is [`MBIDocumentOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios//Protocols/MBIDocumentOverlayViewControllerDelegate.html) protocol. It is necessary to conform to that protocol. We will discuss more about protocols in [Advanced integration section](#advanced-integration). You can use the following default implementation of the protocol to get you started.

Swift

```swift
func documentOverlayViewControllerDidFinishScanning(_ documentOverlayViewController: MBIDocumentOverlayViewController, state: MBIRecognizerResultState) {

    // this is done on background thread
    // check for valid state
    if state == .valid {

        // first, pause scanning until we process all the results
        documentOverlayViewController.recognizerRunnerViewController?.pauseScanning()

        DispatchQueue.main.async(execute: {() -> Void in
            // All UI interaction needs to be done on main thread
        })
    }
}

func documentOverlayViewControllerDidTapClose(_ documentOverlayViewController: MBIDocumentOverlayViewController) {
    // Your action on cancel
}
```

Objective-C

```objective-c
- (void)documentOverlayViewControllerDidFinishScanning:(MBIDocumentOverlayViewController *)documentOverlayViewController state:(MBIRecognizerResultState)state {

    // this is done on background thread
    // check for valid state
    if (state == MBIRecognizerResultStateValid) {

        // first, pause scanning until we process all the results
        [documentOverlayViewController.recognizerRunnerViewController pauseScanning];

        dispatch_async(dispatch_get_main_queue(), ^{
            // All UI interaction needs to be done on main thread
        });
    }
}

- (void)documentOverlayViewControllerDidTapClose:(MBIDocumentOverlayViewController *)documentOverlayViewController {
    // Your action on cancel
}
```

# <a name="advanced-integration"></a> Advanced BlinkInput integration instructions
This section covers more advanced details of BlinkInput integration.

1. [First part](#ui-customizations) will cover the possible customizations when using UI provided by the SDK.
2. [Second part](#using-document-overlay-viewcontroller) will describe how to embed [`MBIRecognizerRunnerViewController's delegates`](http://blinkinput.github.io/blinkinput-ios/Protocols.html) into your `UIViewController` with the goal of creating a custom UI for scanning, while still using camera management capabilites of the SDK.
3. [Third part](#direct-api-processing) will describe how to use the [`MBIRecognizerRunner`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerRunner.html) (Direct API) for recognition directly from `UIImage` without the need of camera or to recognize camera frames that are obtained by custom camera management.
4. [Fourth part](#recognizer) will describe recognizer concept and available recognizers.


## <a name="ui-customizations"></a> Built-in overlay view controllers and overlay subviews

Within BlinkInput SDK there are several built-in overlay view controllers and scanning subview overlays that you can use to perform scanning. 
### <a name="using-pdf417-overlay-viewcontroller"></a> Using `MBIBarcodeOverlayViewController`

[`MBIBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBarcodeOverlayViewController.html) is overlay view controller best suited for performing scanning of various barcodes. It has [`MBIBarcodeOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIBarcodeOverlayViewControllerDelegate.html) delegate which can be used out-of-the-box to perform scanning using the default UI. Here is an example how to use and initialize [`MBIBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBarcodeOverlayViewController.html):

Swift
```swift
/** Create your overlay view controller */
let barcodeOverlayViewController : MBIBarcodeOverlayViewController = MBIBarcodeOverlayViewController(settings: barcodeSettings, recognizerCollection: recognizerCollection, delegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C
```objective-c
MBIBarcodeOverlayViewController *overlayVC = [[MBIBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection: recognizerCollection delegate:self];
UIViewController<MBIRecognizerRunnerViewController>* recognizerRunnerViewController = [MBIViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBIBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBarcodeOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBIBarcodeOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIBarcodeOverlayViewControllerDelegate.html) protocol.
### <a name="using-fieldbyfield-overlay-viewcontroller"></a> Using `MBIFieldByFieldOverlayViewController`

[`MBIFieldByFieldOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFieldByFieldOverlayViewController.html) is overlay view controller best suited for performing scanning of various payment slips and barcodes with field of view. It has [`MBIFieldByFieldOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIFieldByFieldOverlayViewControllerDelegate.html) delegate which can be used out-of-the-box to perform scanning using the default UI. Here is an example how to use and initialize [`MBIFieldByFieldOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFieldByFieldOverlayViewController.html):

Swift
```swift
/** Create your overlay view controller */
let fieldByFieldOverlayViewController : MBIFieldByFieldOverlayViewController = MBIFieldByFieldOverlayViewController(settings: fieldByFieldOverlaySettings, recognizerCollection: recognizerCollection, delegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: fieldByFieldOverlayViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C
```objective-c
MBIFieldByFieldOverlayViewController *overlayVC = [[MBIFieldByFieldOverlayViewController alloc] initWithSettings:settings recognizerCollection: recognizerCollection delegate:self];
UIViewController<MBIRecognizerRunnerViewController>* recognizerRunnerViewController = [MBIViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBIFieldByFieldOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFieldByFieldOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBIFieldByFieldOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIFieldByFieldOverlayViewControllerDelegate.html) protocol.


### <a name="using-documentcapture-overlay-viewcontroller"></a> Using `MBIDocumentCaptureOverlayViewController`

[`MBIDocumentCaptureOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentCaptureOverlayViewController.html) is overlay view controller best suited for performing captureing cropped document images. It has [`MBIDocumentCaptureOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIDocumentCaptureOverlayViewControllerDelegate.html) delegate which can be used out-of-the-box to perform scanning using the default UI. Here is an example how to use and initialize [`MBIDocumentCaptureOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFieldByFieldOverlayViewController.html):

Swift
```swift
/** Create your overlay view controller */
let documentCaptureOverlayViewController : MBIDocumentCaptureOverlayViewController = MBIDocumentCaptureOverlayViewController(settings: settings, recognizer: documentCaptureRecognizer, delegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentCaptureOverlayViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C
```objective-c
MBIDocumentCaptureOverlayViewController *overlayVC = [[MBIDocumentCaptureOverlayViewController alloc] initWithSettings:settings recognizer: documentCaptureRecognizer delegate:self];
UIViewController<MBIRecognizerRunnerViewController>* recognizerRunnerViewController = [MBIViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBIDocumentCaptureOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentCaptureOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBIDocumentCaptureOverlayViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIDocumentCaptureOverlayViewControllerDelegate.html) protocol.
### <a name="using-custom-overlay-viewcontroller"></a> Custom overlay view controller

Please check our Samples for custom implementation of overlay view controller.

Overlay View Controller is an abstract class for all overlay views.

It's responsibility is to provide meaningful and useful interface for the user to interact with.

Typical actions which need to be allowed to the user are:

- intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
- a way to cancel the scanning, typically with a "cancel" or "back" button
- a way to power on and off the light (i.e. "torch") button

BlinkInput SDK always provides it's own default implementation of the Overlay View Controller for every specific use. Your implementation should closely mimic the default implementation as it's the result of thorough testing with end users. Also, it closely matches the underlying scanning technology.

For example, the scanning technology usually gives results very fast after the user places the device's camera in the expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user. The majority of time the user spends on positioning the device's camera correctly. That's just an example which demonstrates careful decision making behind default camera overlay view.

### 1. Subclassing

To use your custom overlay with Microblink's camera view, you must first subclass [`MBICustomOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBICustomOverlayViewController.html) and implement the overlay behaviour conforming wanted protocols.

### 2. Protocols

There are five [`MBIRecognizerRunnerViewController`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIRecognizerRunnerViewController.html) protocols and one overlay protocol [`MBIOverlayViewControllerInterface`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIOverlayViewControllerInterface.html).

Five `RecognizerRunnerView` protocols are:
- [`MBIScanningRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIScanningRecognizerRunnerViewControllerDelegate.html)
- [`MBIDetectionRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIDetectionRecognizerRunnerViewControllerDelegate.html)
- [`MBIOcrRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIOcrRecognizerRunnerViewControllerDelegate.html)
- [`MBIDebugRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIDebugRecognizerRunnerViewControllerDelegate.html)
- [`MBIRecognizerRunnerViewControllerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIRecognizerRunnerViewControllerDelegate.html)

In `viewDidLoad`, other protocol conformation can be done and it's done on `recognizerRunnerViewController` property of [`MBIOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIOverlayViewController.html), for example:

Swift and Objective-C
```swift
self.scanningRecognizerRunnerViewControllerDelegate = self;
```

### 3. Initialization
In [Quick Start](#quick-start) guide it is shown how to use a default overlay view controller. You can now swap default view controller with your implementation of `CustomOverlayViewController`

Swift
```swift
let recognizerRunnerViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: CustomOverlayViewController)
```

Objective-C
```objective-c
UIViewController<MBIRecognizerRunnerViewController>* recognizerRunnerViewController = [MBIViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:CustomOverlayViewController];
```

## <a name="direct-api-processing"></a> Direct processing API

This guide will in short present you how to process UIImage objects with BlinkInput SDK, without starting the camera video capture.

With this feature you can solve various use cases like:
	- recognizing text on images in Camera roll
	- taking full resolution photo and sending it to processing
	- scanning barcodes on images in e-mail etc.

DirectAPI-sample demo app here will present UIImagePickerController for taking full resolution photos, and then process it with BlinkInput SDK to get scanning results using Direct processing API.

Direct processing API is handled with [`MBIRecognizerRunner`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerRunner.html). That is a class that handles processing of images. It also has protocols as [`MBIRecognizerRunnerViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerRunnerViewController.html).
Developer can choose which protocol to conform:

- [`MBIScanningRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIScanningRecognizerRunnerDelegate.html)
- [`MBIDetectionRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIDetectionRecognizerRunnerDelegate.html)
- [`MBIDebugRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIDebugRecognizerRunnerDelegate.html)
- [`MBIOcrRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIOcrRecognizerRunnerDelegate.html)

In example, we are conforming to [`MBIScanningRecognizerRunnerDelegate`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBIScanningRecognizerRunnerDelegate.html) protocol.

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Swift
```swift
func setupRecognizerRunner() {
    var recognizers = [MBIRecognizer]()
    pdf417Recognizer = MBIPdf417Recognizer()
    recognizers.append(pdf417Recognizer!)
    let recognizerCollection = MBIRecognizerCollection(recognizers: recognizers)
    recognizerRunner = MBIRecognizerRunner(recognizerCollection: recognizerCollection)
    recognizerRunner?.scanningRecognizerRunnerDelegate = self
}

func processImageRunner(_ originalImage: UIImage) {
    var image: MBIImage? = nil
    if let anImage = originalImage {
        image = MBIImage(uiImage: anImage)
    }
    image?.cameraFrame = true
    image?.orientation = MBIProcessingOrientation.left
    let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample-swift")
    _serialQueue.async(execute: {() -> Void in
        self.recognizerRunner?.processImage(image!)
    })
}

func recognizerRunner(_ recognizerRunner: MBIRecognizerRunner, didFinishScanningWith state: MBIRecognizerResultState) {
    if blinkInputRecognizer.result.resultState == MBIRecognizerResultStateValid {
        // Handle result
    }
}
```

Objective-C
```objective-c
- (void)setupRecognizerRunner {
    NSMutableArray<MBIRecognizer *> *recognizers = [[NSMutableArray alloc] init];

    self.pdf417Recognizer = [[MBIPdf417Recognizer alloc] init];

    [recognizers addObject: self.pdf417Recognizer];

    MBIRecognizerCollection *recognizerCollection = [[MBIRecognizerCollection alloc] initWithRecognizers:recognizers];

    self.recognizerRunner = [[MBIRecognizerRunner alloc] initWithRecognizerCollection:recognizerCollection];
    self.recognizerRunner.scanningRecognizerRunnerDelegate = self;
}

- (void)processImageRunner:(UIImage *)originalImage {
    MBIImage *image = [MBIImage imageWithUIImage:originalImage];
    image.cameraFrame = YES;
    image.orientation = MBIProcessingOrientationLeft;
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.microblink.DirectAPI-sample", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_serialQueue, ^{
        [self.recognizerRunner processImage:image];
    });
}

- (void)recognizerRunner:(nonnull MBIRecognizerRunner *)recognizerRunner didFinishScanningWithState:(MBIRecognizerResultState)state {
    if (self.blinkInputRecognizer.result.resultState == MBIRecognizerResultStateValid) {
        // Handle result
    }
}
```

Now you've seen how to implement the Direct processing API.

In essence, this API consists of two steps:

- Initialization of the scanner.
- Call of `- (void)processImage:(MBIImage *)image;` method for each UIImage or CMSampleBufferRef you have.


### <a name="direct-api-string-processing"></a> Using Direct API for `NSString` recognition (parsing)

Some recognizers support recognition from `NSString`. They can be used through Direct API to parse given `NSString` and return data just like when they are used on an input image. When recognition is performed on `NSString`, there is no need for the OCR. Input `NSString` is used in the same way as the OCR output is used when image is being recognized.
Recognition from `String` can be performed in the same way as recognition from image.
The only difference is that user should call `- (void)processString:(NSString *)string;` on [`MBIRecognizerRunner`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerRunner.html).

# <a name="recognizer"></a> `MBIRecognizer` and available recognizers

## The `MBIRecognizer` concept

The [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) is the basic unit of processing within the SDK. Its main purpose is to process the image and extract meaningful information from it. As you will see [later](#available-recognizers), the SDK has lots of different [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects that have various purposes.

Each [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) has a [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) object, which contains the data that was extracted from the image. The [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) object is a member of corresponding [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object its lifetime is bound to the lifetime of its parent [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object. If you need your `MBIRecognizerResult` object to outlive its parent [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object, you must make a copy of it by calling its method `copy`.

While [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object works, it changes its internal state and its result. The [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object's [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) always starts in `Empty` state. When corresponding [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object performs the recognition of given image, its [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) can either stay in `Empty` state (in case [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html)failed to perform recognition), move to `Uncertain` state (in case [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) performed the recognition, but not all mandatory information was extracted) or move to `Valid` state (in case [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) performed recognition and all mandatory information was successfully extracted from the image).

As soon as one [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object's [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) within [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html) given to `MBIRecognizerRunner` or `MBIRecognizerRunnerViewController` changes to `Valid` state, the `onScanningFinished` callback will be invoked on same thread that performs the background processing and you will have the opportunity to inspect each of your [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects' [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) to see which one has moved to `Valid` state.

As soon as `onScanningFinished` method ends, the `MBIRecognizerRunnerViewController` will continue processing new camera frames with same [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects, unless `paused`. Continuation of processing or `reset` recognition will modify or reset all [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects's [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html). When using built-in activities, as soon as `onScanningFinished` is invoked, built-in activity pauses the `MBIRecognizerRunnerViewController` and starts finishing the activity, while saving the [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html) with active [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html).

## `MBIRecognizerCollection` concept

The [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html) is is wrapper around [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects that has array of [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects that can be used to give [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects to `MBIRecognizerRunner` or `MBIRecognizerRunnerViewController` for processing.

The [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html) is always constructed with array `[[MBIRecognizerCollection alloc] initWithRecognizers:recognizers]` of [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects that need to be prepared for recognition (i.e. their properties must be tweaked already).

The [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html) manages a chain of [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects within the recognition process. When a new image arrives, it is processed by the first [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) in chain, then by the second and so on, iterating until a [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object's [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) changes its state to `Valid` or all of the [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects in chain were invoked (none getting a `Valid` result state).

You cannot change the order of the [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects within the chain - no matter the order in which you give [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects to [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html), they are internally ordered in a way that provides best possible performance and accuracy. Also, in order for SDK to be able to order [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects in recognition chain in a best way possible, it is not allowed to have multiple instances of [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects of the same type within the chain. Attempting to do so will crash your application.

# <a name="available-recognizers"></a> List of available recognizers

This section will give a list of all [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) objects that are available within BlinkInput SDK, their purpose and recommendations how they should be used to get best performance and user experience.

## <a name="frame-grabber-recognizer"></a> Frame Grabber Recognizer

The [`MBIFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFrameGrabberRecognizer.html) is the simplest recognizer in SDK, as it does not perform any processing on the given image, instead it just returns that image back to its `onFrameAvailable`. Its result never changes state from empty.

This recognizer is best for easy capturing of camera frames with `MBIRecognizerRunnerViewController`. Note that [`MBIImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIImage.html) sent to `onFrameAvailable` are temporary and their internal buffers all valid only until the `onFrameAvailable` method is executing - as soon as method ends, all internal buffers of [`MBIImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIImage.html) object are disposed. If you need to store [`MBIImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIImage.html) object for later use, you must create a copy of it by calling `copy`.

## <a name="success-frame-grabber-recognizer"></a> Success Frame Grabber Recognizer

The [`MBISuccessFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBISuccessFrameGrabberRecognizer.html) is a special `MBIecognizer` that wraps some other [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) and impersonates it while processing the image. However, when the [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) being impersonated changes its [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) into `Valid` state, the [`MBISuccessFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBISuccessFrameGrabberRecognizer.html) captures the image and saves it into its own [`MBISuccessFrameGrabberRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBISuccessFrameGrabberRecognizerResult.html) object.

Since [`MBISuccessFrameGrabberRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBISuccessFrameGrabberRecognizer.html)  impersonates its slave [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object, it is not possible to give both concrete [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object and `MBISuccessFrameGrabberRecognizer` that wraps it to same `MBIRecognizerCollection` - doing so will have the same result as if you have given two instances of same [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) type to the [`MBIRecognizerCollection`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerCollection.html) - it will crash your application.

This recognizer is best for use cases when you need to capture the exact image that was being processed by some other [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizer.html) object at the time its [`MBIRecognizerResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRecognizerResult.html) became `Valid`. When that happens, `MBISuccessFrameGrabberRecognizer's` `MBISuccessFrameGrabberRecognizerResult` will also become `Valid` and will contain described image.

## <a name="pdf417-recognizer"></a> PDF417 recognizer

The [`MBIPdf417Recognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIPdf417Recognizer.html) is recognizer specialised for scanning [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417). This recognizer can recognize only PDF417 2D barcodes - for recognition of other barcodes, please refer to [BarcodeRecognizer](#barcode-recognizer).

This recognizer can be used in any overlay view controller, but it works best with the [`MBIBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.

## <a name="barcode-recognizer"></a> Barcode recognizer

The [`MBIBarcodeRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBarcodeRecognizer.html) is recognizer specialised for scanning various types of barcodes. This recognizer should be your first choice when scanning barcodes as it supports lots of barcode symbologies, including the [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417), thus making [PDF417 recognizer](#pdf417-recognizer) possibly redundant, which was kept only for its simplicity.

You can enable multiple barcode symbologies within this recognizer, however keep in mind that enabling more barcode symbologies affect scanning performance - the more barcode symbologies are enabled, the slower the overall recognition performance. Also, keep in mind that some simple barcode symbologies that lack proper redundancy, such as [Code 39](https://en.wikipedia.org/wiki/Code_39), can be recognized within more complex barcodes, especially 2D barcodes, like [PDF417](https://en.wikipedia.org/wiki/PDF417).

This recognizer can be used in any overlay view controller, but it works best with the [`MBIBarcodeOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.
## <a name="blinkinput-recognizer"></a> BlinkInput recognizer

The [`MBIBlinkInputRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIBlinkInputRecognizer.html) is generic OCR recognizer used for scanning segments which enables specifying `MBIProcessors` that will be used for scanning. Most commonly used `MBIProcessor` within this recognizer is [`MBIParserGroupProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIParserGroupProcessor.html)) that activates all `MBIParsers` in the group to extract data of interest from the OCR result.

This recognizer can be used in any context. It is used internally in the implementation of the provided [`MBIFieldByFieldOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFieldByFieldOverlayViewController.html).

`MBIProcessors` are explained in [The Processor concept](#processor-concept) section and you can find more about `MBIParsers` in [The Parser concept](#parser-concept) section.

## <a name="detector-recognizer"></a> Detector recognizer

The [`MBIDetectorRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDetectorRecognizer.html) is recognizer for scanning generic documents using custom `MBIDetector`. You can find more about `Detector` in [The Detector concept](#detector-concept) section. `MBIDetectorRecognizer` can be used simply for document detection and obtaining its image. The more interesting use case is data extraction from the custom document type. `MBIDetectorRecognizer` performs document detection and can be configured to extract fields of interest from the scanned document by using **Templating API**. You can find more about Templating API in [this](#detector-templating) section.

## <a name="document-capture-recognizer"></a> Document Capture recognizer

The [`MBIDocumentCaptureRecognizer`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentCaptureRecognizer.html) is used for taking cropped document images.
This recognizer can be used in any context, but it works best with the [`MBIDocumentCaptureOverlayViewController`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentCaptureOverlayViewController.html) which takes high resolution document images and guides the user through the image capture process.
# <a name="processors-and-parsers"></a> `MBIProcessor` and `MBIParser`

The `MBIProcessors` and `MBIParsers` are standard processing units within *BlinkInput* SDK used for data extraction from the input images. Unlike the [`MBIRecognizer`](#recognizer-concept), `MBIProcessor` and `MBIParser` are not stand-alone processing units. `MBIProcessor` is always used within `MBIRecognizer` and `MBIParser` is used within appropriate `MBIProcessor` to extract data from the OCR result.

## <a name="processor-concept"></a> The `MBIProcessor` concept

`MBIProcessor` is a processing unit used within some `Recognizer` which supports processors. It process the input image prepared by the enclosing `Recognizer` in the way that is characteristic to the implementation of the concrete `MBIProcessor`.

`MBIProcessor` architecture is similar to `MBIRecognizer` architecture described in [The Recognizer concept](#recognizer-concept) section. Each instance also has associated inner `MBIRecognizerResult` object whose lifetime is bound to the lifetime of its parent `MBIProcessor` object and it is updated while `MBIProcessor` works. If you need your `MBIRecognizerResult` object to outlive its parent `MBIProcessor` object, you must make a copy of it by calling its method `copy`.

It also has its internal state and while it is in the *working state* during recognition process, it is not allowed to tweak `MBIProcessor` object's properties.

To support common use cases, there are several different `MBIProcessor` implementations available. They are listed in the next section.

##  <a name="available-processors"></a> List of available processors

This section will give a list of `MBIProcessor` types that are available within *BlinkInput* SDK and their purpose.

### <a name="image-processors"></a> Image Return Processor

The [`MBIImageReturnProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIImageReturnProcessor.html) is used for obtaining input images. It simply saves the input image and makes it available after the scanning is done.

The appearance of the input image depends on the context in which `MBIImageReturnProcessor` is used. For example, when it is used within [`MBIBlinkInputRecognizer`](#blinkinput-recognizer), simply the raw image of the scanning region is processed. When it is used within the [`Templating API`](#detector-templating), input image is dewarped (cropped and rotated).

The image is returned as the raw [`MBIImage`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIImage.html) type. Also, processor can be configured to [encode saved image to JPEG](http://blinkinput.github.io/blinkinput-ios/Classes/MBIImageReturnProcessor.html).

### <a name="parser-group-processor"></a> Parser Group Processor


The [`MBIParserGroupProcessor`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIParserGroupProcessor.html) is the type of the processor that performs the OCR (*Optical Character Recognition*) on the input image and lets all the parsers within the group to extract data from the OCR result. The concept of `MBIParser` is described in [the next](#parser-concept) section.

Before performing the OCR, the best possible OCR engine options are calculated by combining engine options needed by each `MBIParser` from the group. For example, if one parser expects and produces result from uppercase characters and other parser extracts data from digits, both uppercase characters and digits must be added to the list of allowed characters that can appear in the OCR result. This is a simplified explanation because OCR engine options contain many parameters which are combined by the `MBIParserGroupProcessor`.

Because of that, if multiple parsers and multiple parser group processors are used during the scan, it is very important to group parsers carefully.

Let's see this on an example: assume that we have two parsers at our disposal: `MBIAmountParser` and `MBIEmailParser`. `MBIAmountParser` knows how to extract amount's from OCR result and requires from OCR only to recognize digits, periods and commas and ignore letters. On the other hand, `MBIEmailParser` knows how to extract e-mails from OCR result and requires from OCR to recognize letters, digits, '@' characters and periods, but not commas.

If we put both `MBIAmountParser` and `MBIEmailParser` into the same `MBIParserGroupProcessor`, the merged OCR engine settings will require recognition of all letters, all digits, '@' character, both period and comma. Such OCR result will contain all characters for `MBIEmailParser` to properly parse e-mail, but might confuse `MBIAmountParser` if OCR misclassifies some characters into digits.

If we put `MBIAmountParser` in one `MBIParserGroupProcessor` and `MBIEmailParser` in another `MBIParserGroupProcessor`, OCR will be performed for each parser group independently, thus preventing the `MBIAmountParser` confusion, but two OCR passes of the image will be performed, which can have a performance impact.

`MBIParserGroupProcessor` is most commonly used `MBIProcessor`. It is used whenever the OCR is needed. After the OCR is performed and all parsers are run, parsed results can be obtained through parser objects that are enclosed in the group. `MBIParserGroupProcessor` instance also has associated inner `MBIParserGroupProcessorResult` whose state is updated during processing and its property [`ocrLayout`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIParserGroupProcessor.html) can be used to obtain the raw [`MBIOcrLayout`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIOcrLayout.html) that was used for parsing data.

Take note that `MBIOcrLayout` is available only if it is allowed by the *BlinkInput* SDK license key. `MBIOcrLayout` structure contains information about all recognized characters and their positions on the image. To prevent someone to abuse that, obtaining of the `MBIOcrLayout` structure is allowed only by the premium license keys.

## <a name="parser-concept"></a> The `MBIParser` concept

`MBIParser` is a class of objects that are used to extract structured data from the raw OCR result. It must be used within `MBIParserGroupProcessor` which is responsible for performing the OCR, so `MBIParser` is not stand-alone processing unit.

Like [`MBIRecognizer`](#recognizer-concept) and all other processing units, each `MBIParser` instance has associated inner `MBIRecognizerResult` object whose lifetime is bound to the lifetime of its parent `MBIParser` object and it is updated while `MBIParser` works. When parsing is done `MBIParserResult` can be used for obtaining extracted data. If you need your `MBIParserResult` object to outlive its parent `MBIParser` object, you must make a copy of it by calling its method `copy`.

It also has its internal state and while it is in the *working state* during recognition process, it is not allowed to tweak `MBIParser` object's properties.

There are a lot of different `MBIParsers` for extracting most common fields which appear on various documents. Also, most of them can be adjusted for specific use cases. For all other custom data fields, there is `RegexParser` available which can be configured with the arbitrary regular expression.

##  <a name="available-parsers"></a> List of available parsers

### <a name="amount-parser"></a> Amount Parser

[`MBIAmountParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIAmountParser.html) is used for extracting amounts from the OCR result.

### <a name="date-parser"></a> Date Parser

[`MBIDateParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDateParser.html) is used for extracting dates in various formats from the OCR result.

### <a name="email-parser"></a> Email Parser

[`MBIEmailParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIEmailParser.html) is used for extracting e-mail addresses from the OCR result.

### <a name="iban-parser"></a> IBAN Parser

[`MBIIbanParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIIbanParser.html) is used for extracting IBAN (*International Bank Account Number*) from the OCR result.

### <a name="license-plate-parser"></a> License Plates Parser

[`MBILicensePlatesParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBILicensePlatesParser.html) is used for extracting license plate content from the OCR result.

### <a name="raw-parser"></a> Raw Parser

[`MBIRawParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRawParser.html) is used for obtaining string version of raw OCR result, without performing any smart parsing operations.

### <a name="regex-parser"></a> Regex Parser

[`MBIRegexParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIRegexParser.html) is used for extracting OCR result content which is in accordance with the given regular expression. Regular expression parsing is not performed with java's regex engine. Instead, it is performed with custom regular expression engine.

### <a name="topup-parser"></a> TopUp Parser

[`MBITopUpParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBITopUpParser.html) is used for extracting TopUp (mobile phone coupon) codes from the OCR result. There exists [`TopUpPreset`](http://blinkinput.github.io/blinkinput-ios/Enums/MBITopUpPreset.html) enum with presets for most common vendors. Method `- (void)setTopUpPreset:(MBITopUpPreset)topUpPreset` can be used to configure parser to only return codes with the appropriate format defined by the used preset.

### <a name="vin-parser"></a> VIN (*Vehicle Identification Number*) Parser

[`MBIVinParser`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIVinParser.html) is used for extracting VIN (*Vehicle Identification Number*) from the OCR result.

# <a name="templating-api"></a> Scanning generic documents with Templating API

This section discusses the setting up of `MBIDetectorRecognizer` for scanning templated documents. Please check `Templating-sample` sample app for source code examples.

Templated document is any document which is defined by its template. Template contains the information about how the document should be detected, i.e. found on the camera scene and information about which part of the document contains which useful information.

## <a name="defining-document-detection"></a> Defining how document should be detected

Before performing OCR of the document, _BlinkInput_ first needs to find its location on a camera scene. In order to perform detection, you need to define [MBIDetector](#detector-concept).

You have to set concrete `MBIDetector` when instantiating the `MBIDetectorRecognizer` as a parameter to its constructor.

You can find out more information about detectors that can be used in section [List of available detectors](#detector-list). The most commonly used detector is [`MBIDocumentDetector`](#document-detector).

## <a name="defining-field-extraction"></a> Defining how fields of interest should be extracted

`MBIDetector` produces its result which contains document location. After the document has been detected, all further processing is done on the detected part of the input image.

There may be one or more variants of the same document type, for example for some document there may be old and new version and both of them must be supported. Because of that, for implementing support for each document, one or multiple templating classes are used. `MBITemplatingClass` is described in [The Templating Class component](#templating-class) section.

`MBITemplatingClass` holds all needed information and components for processing its class of documents. Templating classes are processed in chain, one by one. On first class for which the data is successfully extracted, the chain is terminated and recognition results are returned. For each input image processing is done in the following way:

1. Classification `MBIProcessorGroups` are run on the defined locations to extract data. `MBIProcessorGroup` is used to define the location of interest on the detected document and `MBIProcessors` that will extract data from that location. You can find more about `MBIProcessorGroup` in the [next section](#processor-group).

2. `MBITemplatingClassifier` is run with the data extracted by the classification processor groups to decide whether the currently scanned document belongs to the current class or not. Its [classify](http://blinkinput.github.io/blinkinput-ios/Protocols/MBITemplatingClassifier.html) method  simply returns `YES/true` or `NO/false`. If the classifier returns `NO/false`, recognition is moved to the next class in the chain, if it exists. You can find more about `MBITemplatingClassifier` in [this](#implementing-templating-classifier) section.

3. If the `MBITemplatingClassifier` has decided that currently scanned document belongs to the current class, non-classification `MBIProcessorGroups` are run to extract other fields of interest.

### <a name="processor-group"></a> The `MBIProcessorGroup` component

In templating API [`MBIProcessorGroup`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIProcessorGroup.html) is used to define the location of the field of interest on the detected document and how that location should be processed by setting following parameters in its constructor:

1. Location coordinates relative to document detection which are passed as [`Rectangle`] object.

2. `MBIDewarpPolicy` which determines the resulting image chunk for processing. You can find a description of each `MBIDewarpPolicy`, its purpose and recommendations when it should be used to get the best results in [List of available dewarp policies](#dewarp-policy-list) section.

3. Collection of processors that will be executed on the prepared chunk of the image for current document location. You can find more information about processors in [The Processor concept](#processor-concept) section.

### <a name="dewarp-policy-list"></a> List of available dewarp policies

Concrete `MBIDewarpPolicy` defines how specific location of interest should be dewarped (cropped and rotated). It determines the height and width of the resulting dewarped image in pixels. Here is the list of available dewarp policies with linked doc for more information:

- [`MBIFixedDewarpPolicy`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIFixedDewarpPolicy.html)
    - defines the exact height of the dewarped image in pixels
    - **usually the best policy for processor groups that use a legacy OCR engine**

- [`MBIDPIBasedDewarpPolicy`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDPIBasedDewarpPolicy.html):
    - defines the desired DPI (*Dots Per Inch*)
    - the height of the dewarped image will be calculated based on the actual physical size of the document provided by the used detector and chosen DPI
    - **usually the best policy for processor groups that prepare location's raw image for output**

- [`MBINoUpScalingDewarpPolicy`](http://blinkinput.github.io/blinkinput-ios/Classes/MBINoUpScalingDewarpPolicy.html):
    - defines the maximal allowed height of the dewarped image in pixels
    - the height of the dewarped image will be calculated in a way that no part of the image will be up-scaled
    - if the height of the resulting image is larger than maximal allowed, then the maximal allowed height will be used as actual height, which effectively scales down the image
    - **usually the best policy for processors that use neural networks, for example,  DEEP OCR, hologram detection or NN-based classification**

### <a name="templating-class"></a> The `MBITemplatingClass` component

[`MBITemplatingClass`](http://blinkinput.github.io/blinkinput-ios/Classes/MBITemplatingClass.html) enables implementing support for a specific class of documents that should be scanned with templating API. Final implementation of the templating recognizer consists of one or more templating classes, one class for each version of the document.

`MBITemplatingClass` contains two collections of `MBIProcessorGroups` and a `MBITemplatingClassifier`.

The two collections of processor groups within `MBITemplatingClass` are:

1. The classification processor groups which are set by using the [`- (void)setClassificationProcessorGroups:(nonnull NSArray<__kindof MBIProcessorGroup *> *)processorGroups`] method. `MBIProcessorGroups` from this collection will be executed before classification, which means that they are always executed when processing comes to this class.

2. The non-classification processor groups which are set by using the [`- (void)setNonClassificationProcessorGroups:(nonnull NSArray<__kindof MBIProcessorGroup *> *)processorGroups`]method. `MBIProcessorGroups` from this collection will be executed after classification if the classification has been positive.

A component which decides whether the scanned document belongs to the current class is [`MBITemplatingClass`](http://blinkinput.github.io/blinkinput-ios/Classes/MBITemplatingClass.html). It can be set by using the `- (void)setTemplatingClassifier:(nullable id<MBITemplatingClassifier>)templatingClassifier` method. If it is not set, non-classification processor groups will not be executed. Instructions for implementing the `MBITemplatingClassifier` are given in the [next section](#implementing-templating-classifier).

### <a name="implementing-templating-classifier"></a> Implementing the `MBITemplatingClassifier`

Each concrete templating classifier implements the [`MBITemplatingClassifier`](http://blinkinput.github.io/blinkinput-ios/Protocols/MBITemplatingClassifier.html) interface, which requires to implement its `classify` method that is invoked while evaluating associated `MBITemplatingClass`.

Classification decision should be made based on the processing result which is returned by one or more processing units contained in the collection of the classification processor groups. As described in [The ProcessorGroup component](#processor-group) section, each processor group contains one or more `MBIProcessors`. [There are different `MBIProcessors`](#processor-list) which may enclose smaller processing units, for example, [`MBIParserGroupProcessor`](#parser-group-processor) maintains the group of [`MBIParsers`](#parser-concept). Result from each of the processing units in that hierarchy can be used for classification. In most cases `MBIParser` result is used to determine whether some data in the expected format exists on the specified location.

To be able to retrieve results from the various processing units that are needed for classification, their instances must be available when `classify` method is called.

## Obtaining recognition results

When recognition is done, results can be obtained through processing units instances, such as: `MBIProcessors`, `MBIParsers`, etc. which are used for configuring the `MBITemplatingRecognizer` and later for processing the input image.

# <a name="detector-concept"></a> The `MBIDetector` concept

[`MBIDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDetector.html) is a processing unit used within some `MBIRecognizer` which supports detectors, such as [`MBIDetectorRecognizer`](#detector-recognizer). Concrete `MBIDetector` knows how to find the certain object on the input image. `MBIRecognizer` can use it to perform object detection prior to performing further recognition of detected object's contents.

`MBIDetector` architecture is similar to `MBIRecognizer` architecture described in [The Recognizer concept](#recognizer-concept) section. Each instance also has associated inner `MBIRecognizerResult` object whose lifetime is bound to the lifetime of its parent `MBIDetector` object and it is updated while `MBIDetector` works. If you need your `MBIRecognizerResult` object to outlive its parent `MBIDetector` object, you must make a copy of it by calling its `copy` method.

It also has its internal state and while it is in the *working state* during recognition process, it is not allowed to tweak `MBIDetector` object's properties.

When detection is performed on the input image, each `MBIDetector` in its associated `MBIDetectorResult` object holds the following information:

- [`MBIDetectionCode`](http://blinkinput.github.io/blinkinput-ios/Enums/MBIDetectionCode.html) that indicates the type of the detection.

- [`MBIDetectionStatus`](http://blinkinput.github.io/blinkinput-ios/Enums/MBIDetectionStatus.html) that represents the status of the detection.

- each concrete detector returns additional information specific to the detector type


To support common use cases, there are several different `MBIDetector` implementations available. They are listed in the next section.

## <a name="detector-list"></a> List of available detectors

### <a name="document-detector"></a> Document Detector

[`MBIDocumentDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentDetector.html) is used to detect card documents, cheques, A4-sized documents, receipts and much more.

It accepts one or more `MBIDocumentSpecifications`. [`MBIDocumentSpecification`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentSpecification.html) represents a specification of the document that should be detected by using edge detection algorithm and predefined aspect ratio.

For the most commonly used document formats, there is a helper method  `+ (instancetype)createFromPreset:(MBIDocumentSpecificationPreset)preset` which creates and initializes the document specification based on the given [`MBIDocumentSpecificationPreset`](http://blinkinput.github.io/blinkinput-ios/Enums/MBIDocumentSpecificationPreset.html).

For the list of all available configuration methods see [`MBIDocumentDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentDetector.html) doc, and for available result content see [`MBIDocumentDetectorResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIDocumentDetectorResult.html) doc.


### <a name="mrtd-detector"></a> MRTD Detector

[`MBIMrtdDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIMrtdDetector.html) is used to perform detection of *Machine Readable Travel Documents (MRTD)*.

Method `- (void)setMrtdSpecifications:(NSArray<__kindof MBIMrtdSpecification *> *)mrtdSpecifications` can be used to define which MRTD documents should be detectable. It accepts the array of `MBIMrtdSpecification`. [`MBIMrtdSpecification`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIMrtdSpecification.html) represents specification of MRTD that should be detected. It can be created from the [`MBIMrtdSpecificationPreset`](http://blinkinput.github.io/blinkinput-ios/Enums/MBIMrtdSpecificationPreset.html) by using `+ (instancetype)createFromPreset:(MBIMrtdSpecificationPreset)preset` method.

If `MBIMrtdSpecifications` are not set, all supported MRTD formats will be detectable.

For the list of all available configuration methods see [`MBIMrtdDetector`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIMrtdDetector.html) doc, and for available result content see [`MBIMrtdDetectorResult`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIMrtdDetectorResult.html) doc.

# <a name="localization"></a> Localization

The SDK is localized on following languages: Arabic, Chinese simplified, Chinese traditional, Croatian, Czech, Dutch, Filipino, French, German, Hebrew, Hungarian, Indonesian, Italian, Malay, Portuguese, Romanian, Slovak, Slovenian, Spanish, Thai, Vietnamese.

If you would like us to support additional languages or report incorrect translation, please contact us at [help.microblink.com](http://help.microblink.com).

If you want to add additional languages yourself or change existing translations, you need to set `customLocalizationFileName` property on [`MBIMicroblinkApp`](http://blinkinput.github.io/blinkinput-ios/Classes/MBIMicroblinkApp.html) object to your strings file name.

For example, let's say that we want to change text "Scan the front side of a document" to "Scan the front side" in BlinkID sample project. This would be the steps:
* Find the translation key in en.strings file inside BlinkInput.framework
* Add a new file MyTranslations.strings to the project by using "Strings File" template
* With MyTranslations.string open, in File inspector tap "Localize..." button and select English
* Add the translation key "blinkid_generic_message" and the value "Scan the front side" to MyTranslations.strings
* Finally in AppDelegate.swift in method `application(_:, didFinishLaunchingWithOptions:)` add `MBIMicroblinkApp.instance()?.customLocalizationFileName = "MyTranslations"`

# <a name="troubleshooting"></a> Troubleshooting

## <a name="troubleshooting-integration-problems"></a> Integration problems

In case of problems with integration of the SDK, first make sure that you have tried integrating it into XCode by following [integration instructions](#quick-start).

If you have followed [XCode integration instructions](#quick-start) and are still having integration problems, please contact us at [help.microblink.com](http://help.microblink.com).

## <a name="troubleshooting-sdk-problems"></a> SDK problems

In case of problems with using the SDK, you should do as follows:

### <a name="troubleshooting-licensing-problems"></a> Licencing problems

If you are getting "invalid licence key" error or having other licence-related problems (e.g. some feature is not enabled that should be or there is a watermark on top of camera), first check the console. All licence-related problems are logged to error log so it is easy to determine what went wrong.

When you have determine what is the licence-relate problem or you simply do not understand the log, you should contact us [help.microblink.com](http://help.microblink.com). When contacting us, please make sure you provide following information:

* exact Bundle ID of your app (from your `info.plist` file)
* licence that is causing problems
* please stress out that you are reporting problem related to iOS version of BlinkInput SDK
* if unsure about the problem, you should also provide excerpt from console containing licence error

### <a name="troubleshooting-other-problems"></a> Other problems

If you are having problems with scanning certain items, undesired behaviour on specific device(s), crashes inside BlinkInput SDK or anything unmentioned, please do as follows:
	
* Contact us at [help.microblink.com](http://help.microblink.com) describing your problem and provide following information:
	* log file obtained in previous step
	* high resolution scan/photo of the item that you are trying to scan
	* information about device that you are using
	* please stress out that you are reporting problem related to iOS version of BlinkInput SDK

## <a name="troubleshooting-faq"></a> Frequently asked questions and known problems
Here is a list of frequently asked questions and solutions for them and also a list of known problems in the SDK and how to work around them.

#### Note on ARM Macs

We are supporting `ARM64 Device` slice through our `.xcframework` format.
We are still in development supporting `ARM64 Simulator` slice for newly released ARM Macs and we will update our SDK with `ARM64 Simulator` support as soon as development is done.

#### In demo everything worked, but after switching to production license I get `NSError` with `MBIMicroblinkSDKRecognizerErrorDomain` and `MBIRecognizerFailedToInitalize` code as soon as I construct specific [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/docs/Classes/MBIRecognizer.html) object

Each license key contains information about which features are allowed to use and which are not. This `NSError` indicates that your production license does not allow using of specific `MBIRecognizer` object. You should contact [support](http://help.microblink.com) to check if provided licence is OK and that it really contains all features that you have purchased.

#### I get `NSError` with `MBIMicroblinkSDKRecognizerErrorDomain` and `MBIRecognizerFailedToInitalize` code with trial license key

Whenever you construct any [`MBIRecognizer`](http://blinkinput.github.io/blinkinput-ios/docs/Classes/MBIRecognizer.html) object or, a check whether license allows using that object will be performed. If license is not set prior constructing that object, you will get `NSError` with `MBIMicroblinkSDKRecognizerErrorDomain` and `MBIRecognizerFailedToInitalize` code. We recommend setting license as early as possible in your app.

#### Undefined Symbols on Architecture armv7

Make sure you link your app with iconv and Accelerate frameworks as shown in [Quick start](#quick-start).
If you are using Cocoapods, please be sure that you've installed `git-lfs` prior to installing pods. If you are still getting this error, go to project folder and execute command `git-lfs pull`.

### Crash on armv7 devices

SDK crashes on armv7 devices if bitcode is enabled. We are working on it.

#### In my `didFinish` callback I have the result inside my `MBIRecognizer`, but when scanning activity finishes, the result is gone

This usually happens when using [`MBIRecognizerRunnerViewController`](http://blinkinput.github.io/blinkinput-ios/docs/Classes/MBIRecognizerRunnerViewController.html) and forgetting to pause the [`MBIRecognizerRunnerViewController`](http://blinkinput.github.io/blinkinput-ios/docs/Classes/MBIRecognizerRunnerViewController.html) in your `didFinish` callback. Then, as soon as `didFinish` happens, the result is mutated or reset by additional processing that `MBIRecognizer` performs in the time between end of your `didFinish` callback and actual finishing of the scanning activity. For more information about statefulness of the `MBIRecognizer` objects, check [this section](#recognizer-concept).

#### Unsupported architectures when submitting app to App Store

BlinkInput.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures.

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

### Disable logging

Logging can be disabled by calling `disableMicroblinkLogging` method on [`MBILogger`](http://blinkinput.github.io/blinkinput-ios/docs/Classes/MBILogger.html) instance.
# <a name="size-report"></a> Size Report

We are delivering complete size report of our BlinkInput SDK based on our BlinkInput-sample-Swift sample project. You can check that [here](https://github.com/BlinkInput/blinkinput-ios/tree/master/size-report).
# <a name="info"></a> Additional info

Complete API reference can be found [here](http://blinkinput.github.io/blinkinput-ios/index.html). 

For any other questions, feel free to contact us at [help.microblink.com](http://help.microblink.com).