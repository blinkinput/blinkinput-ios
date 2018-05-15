# Release notes

## 4.0.0

- new API, which is not backward compatible. Please check [README](README.md) and updated demo applications for more information, but the gist of it is:
    - `PPScanningViewController` has been renamed to `MBRecognizerRunnerViewController` and `MBCoordinator` to `MBRecognizerRunner`
    - `PPBarcodeOverlayViewController` has been renamed to `MBBarcodeOverlayViewController`
    - previously internal `MBRecognizer` objects are not internal anymore - instead of having opaque `MBRecognizerSettings` and `MBRecognizerResult` objects, you now have stateful `MBRecognizer` object that contains its `MBResult` within and mutates it while performing recognition. For more information, see [README](README.md) and updated demo applications
    - introduced `MBFieldByFieldOverlayViewController` that can be used for easy integration of the _field-by-field scanning_ feature (previously known as _segment scan_)
    - introduced `MBProcessor` concept. For more information, check updated code samples, [README](README.md) and [this blog post](https://microblink.com/blog/major-change-of-the-api-and-in-the-license-key-formats)
- new licence format, which is not backward compatible. Full details are given in [README](README.md) and in updated applications, but the gist of it is:
    - licence can now be provided with either file, byte array or base64-encoded bytes

## 2.3.0

- Updates and additions:
	- Microblink.framework is now a dynamic framework. The change is introduced because of the following reasons:
        - isolation of code
        - smaller binary size
        - better interop with third party libraries (such as Asseco SEE Mobile Token)
    - improved Screen shown when Camera permission is not granted:
        - fixed crash which happened on tap anywhere on screen
        - close button can now be removed (for example, if the scanning screen is inside `UINavigationController` instance)
        - header is now public so you can instantiate that class if needed
    - updated `PPUiSettings` with new features:
        - flag `showStatusBar` which you can use to show or hide status bar on camera screen 
        - flag `showCloseButton` which you can use to show or hide close button on camera screen. By default it's presented, but when inside `UINavigationController` it should be hidden
        - flag `showTorchButton` which you can use to show or hide torch button on camera screen.
    - deprecated `PPHelpDisplayMode`. You should replace it with a custom logic for presenting help inside the application using the SDK.
    - renamed internal extension method with namespace so that they don't interfere with third party libraries
    - added standard tap to focus overlay subview in all default OverlayViewControllers. Also added it as a public header.
    - `PScanningViewController` now has a simple method to turn on torch
    - simplified `PPOcrLayout` class (removed properties which were not used)
	- internal switch to new build system using cmake. This allows faster deployments and easier updates in the future
 	- added support for hungarian parsers in segment scan
		- account number parser
		- payer ID parser
	- added support for slovenian parsers in segment scan
		- reference parser
	- all recognizer results (classes that derive `PPRecognizerResult`) now have annotated nullability for their getters. Some of them used to assume non-null, while still returning `nil` sometimes. This has now been corrected and all getters are `_Nullable`
	- added support for scanning IBANs that contain spaces and dashes
	- added support for scanning IBAN from Georgia in Segment Scan
	- added Belgian account number check to IBAN parser
	- added Slovak Data Matrix codes
	- added property `allowResultForEveryFrame` in `PPScanSettings` which can be used when using Direct API to force calling `didOutputResults:` callback for every frame
	- added feature to enable frame quality estimation when using Direct API (by exposing property `estimateFrameQuality`)
	- added logging of the SDK name when the license key is invalid for easier troubleshooting
	- added a property which you can use to set a custom location for resources. For example, if you would like to avoid using Microblink.bundle as resources bundle, you can set a different one in PPSettings object
	- added `PPSimNumberRecognizer`
	- added Generic parsing in TopUpOcrParser
	- added designated initializers to all `PPOcrParserFactory` objects
	- added play success sound method to `PPScanningViewController` protocol
	- added Barcode Recognizer `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
    - deprecated `PPBarDecoderRecognizerResult` and `PPBarDecoderRecognizerSettings`. Use Barcode Recognizer
    - deprecated `PPZXingRecognizerResult` and `PPZXingRecognizerSettings`. Use Barcode Recognizer
    - `PPBlinkOcrRecognizerResult` and `PPBlinkOcrRecognizerSettings` are now deprecated. Use `PPDetectorRecognizerResult` and `PPDetectorRecognizerSettings` for templating or `PPBlinkInputRecognizerResult` and `PPBlinkInputRecognizerSettings` for segment scan
    - added reading of mirrored QR codes
    - introduced `GlareDetector` which is by default used in all recognizers whose settings implement `GlareDetectorOptions`:
        - when glare is detected, OCR will not be performed on the affected document position to prevent errors in the extracted data
        - if the glare detector is used and obtaining of glare metadata is enabled in `MetadataSettings`
        - glare detector can be disabled by using `detectGlare` property on the recognizer settings
    - added `PPQuadDetectorResultWithSize` which inherits existing `PPQuadDetectorResult`
        - it's subclasses are `PPDocumentDetectorResult` and `PPMrtdDetectorResult`
        - returns information about physical size (height) in inches of the detected location when physical size is known   
    - `CFBundleShortVersionString` is now updated with each release

- Bugfixes:
	- fixed frame quality issue in PPimageMetadata. Previously it was always nan if used after image getter
	- fixed Torch button on default camera overlays. Previously it never changed state after it was turned on
	- Fixed crash when the user tapped anywhere on the view controller presented when camera permission wasn't allowed
	- fixed warning message when language is set to something other than @en, @de and @fr and @cro
	- fixed crash on start in swift if custom UI was used to handle detector results
	- fixed a problem which caused internal recognizer state not to be reset when using the scanner for the second time with the same PPCoordinator instance
	- fixed ocrLayout getter in PPBlinkOcrRecognizer which previously returned nil
	- fixed an issue which caused camera settings to be reset each time PPCoordinator's applySettings method was called. This issue manifested, for example, by automatically turning off torch after successful scan in SegmentScan
	- fixed redundant log warnings in setting language ("Trying to set language to nil, returning") and CameraManager ("Should not have been observing autofocus")
	- fixed issue with resuming camera when user is first asked for camera permission. This manifested as sometimes camera going black
	- fixed issue with blurred camera display when `PPCoordinator` instance was reused between consecutive scanning sessions
	- fixed crashed which happened when multiple instances of `PPCoordinator` were used simultaneously (one being terminated and one starting recognition). This most commonly happened when after scanning session, a new view controller was pushed to a Navigation View Controller, when the user repeated the procedure a number of times (five or more).
	- fixed issue with Direct API which disabled processing
	- fixed crash when multiple QR code-based recognizers were used together
	- fixed bug which caused didOutputResults: not to get called in DirectAPI
    - fixed case sensitivity in class & file naming
    - fixed issue which sometimes caused scanning not to be started when the user is asked for camera permission (first run of the app)
    - fixed rare crash which Camera paused label UI being updated on background thread
    - fixed incorrect handling of camera mirror when using front facing camera
    - fixed crash which sometimes happened when presenting help screens (if `PPHelpDisplayModeAlways` or `PPHelpDisplayModeFirstRun` were used)
    - fixed crash in QR code which happened periodically in all recognizers
    - fixed autorotation of overlay view controller
    - fixed scanning return result type of `PPDetectorRecognizerSettings` when initialized with `PPMrtdDetectorSettings` - returning `PPMrtdDetectorResult`

- Improvements in ID scanning performance:
	- improved IBAN parser
	- improved amount parser
	- improved Croatian Reference number parsing:
		- trailing whitespace is removed from result when using Segment scanning
	- improved `TopUpParser`: added option to enable all prefixes at the same time (generic prefix)	
	- added suport for 14 digits long sim numbers in addition to existing lengths (12, 19, 20)
    - TopUp scanning improvements
    - improved reading of pdf417 barcodes having width:height bar aspect ratio less than 2:1
    - date parsing improvements
    - added parsing of curly brackets

- Changes in Samples:
     - added libz to all samples to prevent linker errors (caused by slimming down the SDK)
     - samples updated to use new dynamic framework
     - added a build phase in each sample which removes unused architectures from the dynamic framework    
     - samples updated for XCode 9
     - all Swift samples are updated to Swift 4

## 2.2.0

- iOS updates:
	- Aded Slovenian ID recognizer
	- Added parser for mobile coupons
	- Added frame quality property to PPImageMetadata
- iOS bugfixes:
	- Fixed issue where Templating API wasn't working as expected on some devices.
	- Fixed issue with string localizations

## 2.1.2

- iOS fixes:
	- CFBundleSUpportedPlatforms removed from Info.plist files
	- Applying affine transformation to `PPQuadrangle` now correctly assigns points.
	- When using both Direct API and `PPCameraCoordinator`, scanning results will now be correctly outputted to `PPCoordinatorDelegate` and `PPScanningDelegate` respectively
	- Fixed crashes related to camera permissions and added dummy view when camera permission is disabled
	- Fixed issues related to topLayoutGuide on iOS6
	- Improved performance of Date parser

## 2.1.1

- iOS bugfixes:
	- Detectors are now built correctly. Incorrect builds caused Templating API not to work as desired

## 2.1.0

- iOS updates:

	- Added option to mirror camera frames in 'PPCameraSettings'
	- Added VIN parser
	
- iOS bugfixes
	- Fixed deadlock when 'processImage:' is called from main thread
	- Fixed setting custom PPOcrEngineOptions

## 2.0.0

- iOS updates:

	- Implemented `PPCameraCoordinator`. `PPCameraCoordinator` assumes the role of `PPCoordinator` from previous versions while new `PPCoordinator` is used for Direct API (image processing without camera out management).
	- Increased speed of scanning for barcode type recognizers.
	- Implemented `PPImage`. When using Direct API you can wrap `UIImage` and `CMSampleBufferRef` into `PPImage` to ensure optimal performance.
	- Improved performance of Direct API. In addition, you can now use Direct API with your own camera management without any performance drawbacks.
	- Added method `isCameraPaused` to `PPScanningViewController`.
	- Added option to fllip input images upside down for processing with `cameraFlipped` property of `PPCameraSettings`.
	- Implemented `PPViewControllerFactory` for managing creation of `PPScanningViewController` objects.
	- `PPImageMetadata` now contains `PPImageMetadataType` property, which describes which image type was outputted.
	- Added VIN (Vehicle idendification number) parser.
	- Mirrored (both horizontally and vertically) images can now be processed by setting PPScanSettings/PPImage properties (latter if using custom camera management).

- Implemented templating API

    - Templating API allows creation of custom document scanners, linking specific parsers to specific locations on detected documents
	
- iOS bugfixes:
	- New Direct API fixed possible deadlocks when sending large amounts of data

## 1.2.0

- iOS bugfixes:

	- fixed potential deadlock when multiple instances of `PPCoordinator` objects are instantiated

- Implemented templating API

    - Templating API allows implementing custom document scanners, linking specific parsers to specific locations on detected documents
	
- Added Regex parser

	- Regex parser allows you to create your custom ocr parser factory
	
- PPOverlayViewController changed the way Overlay Subviews are added to the view hierarchy. Instead of calling `addOverlaySubview:` (which automatically added a view to view hierarachy), you now need to call `registerOverlaySubview:` (which registers subview for scanning events), and manually add subview to view hierarchy using `addSubview:` method. This change gives you more flexibility for adding views and managing autolayout and autoresizing masks.

- Better Swift interoperability
    - Support for modules
    - Added nullability annotations
	
- Framework is now distributed as a .framework + .bundle, instead of .embeddedframework. This helps keep resources in a separate "namespace", and avoids mistakes

- The library inside the framework is now static library. This makes it easier to include the library inside other libraries

- Added bitcode support for Xcode 7

## 1.1.1

- Added support for using BlinkOCR as a camera capture API. To do that, implement the following

    - When initializing the `PPCoordinator` object, don't add any `PPRecognizerSettings` to `scanSettings`.
    - Use `settings.metadataSettings.currentVideoFrame = YES` to capture current camera frame
    - Implement `scanningViewController:didOutputMetadata:` callback to obtain `PPImageMetadata` objects with camera frames.
    
- As a reminder - you can process video frames obtained in that way using direct API method `processImage:scanningRegion:delegate:`

## 1.1.0

- Added support for Barcode recognition using the following recognizers: 

    - `PPPdf417Recognizer` for scanning PDF417 barcodes
    - `PPBarDecoderRecognizer` for Code 39 and Code 128 1D barcodes
    - `PPZXingRecognizer` for all other 1D and 2D barcode types
    
- Barcode scanning can be used **at the same time** with OCR scanning, or completely separate. Use different `scanSettings`.

- Improved video frame quality detection: now only the sharpest and the most focused frames are being processed. This improves quality of the results, but at a slight expense of processing time

- Frame quality estimation can now be enabled using `PPScanSettings frameQualityEstimationMode` property:
    - when set to `PPFrameQualityEstimationModeOn`, frame quality estimation is always enabled
    - when set to `PPFrameQualityEstimationModeOff`, frame quality estimation is always disabled
    - when set to `PPFrameQualityEstimationModeDefault`, frame quality estimation is enabled internally, if the SDK determines it makes sense
    
- iOS 9 introduced new app multitasking features Split View and Slide Over. When the scanner is on screen and one of those features are used, iOS automatically pauses the Camera (this behaviour is default as of iOS 9 beta 5). This SDK version introduces new setting in `PPUISettings` class, called `cameraPausedView`, where you can define the `UIView` which is presented centered on screen when this happens.

- Known issue on iOS 9: if you use Autorotate overlay feature (`settings.uiSetttings.autorotateOverlay`), present `PPScanningViewController` as a modal view controller, and support Split View iOS 9 feature, then autorotation of camera overlays isn't correct. The best way is to opt-out of Split View feature, and wait for SDK fix when iOS 9 comes out of beta.

- `PPScanningViewController` methods `pauseScanning`, `isScanningPaused`, and `resumeScanningAndResetState:` should now be called only from Main thread, and they are effective immediately. E.g., if `pauseScanning` is called and there is a video frame being processed, result of processing of that frame will be discarded, if `resumeScanningAndResetState:` isn't called in the meantime.

- Added support for `PPCameraPresetPhoto` camera preset. Use this if you need the same zoom level as in iOS Camera app. The resolution for video feed when using this preset is the same as devices screen resolution.

## 1.0.0

- BlinkOCR now supports several new fonts, which especially benefit receipt scanning use case.
    
    - Use them by specifying a whitelist of CharKeys in `PPOcrEngineOptions`
    - New fonts are:
        
        - `PP_OCR_FONT_CHAINPRINTER`
        - `PP_OCR_FONT_HYPERMARKET`
        - `PP_OCR_FONT_PRINTF`
        - `PP_OCR_FONT_TICKET_DE_CAISSE`
        
- You can now access two more properties of `PPOcrChar` objects

    - font - to get information about the font of the char
    - variants - to get a set of all alternative values for a specific char (note: a variant is defined as a combination of a unicode value + font, so there might be the same characters multiple times in the variants set - each time with different font)

- `PPOcrEngineOptions` now have the ability to turn off line grouping (collecting adjacent chars into lines) with `lineGroupingEnabled` property.

- Changes in Direct processing API
    - You are no longer required to call `PPCoordinator initializeRecognizers` and `PPCoordinator terminateRecognizers`.
    - Instead, `initializeRecognizers` is called lazily on first call of `processImage` method. 
    - `terminateRecognizers` is called automatically in `PPCoordinator` destructor 
    
- Added support for autorotation of `PPScanningViewController`. To support autorotation, use `PPScanningViewController`'s new properties `autorotate` and `supportedOrientations`

- countless tweaks and fixes in OCR engine

## 0.9.6

- Added `didOutputMetadata` callback method to `PPOverlayViewControllers`

- Fixed bug which caused Overlay events to be called when direct (static) OCR processing is used. Direct OCR processing now only reports events to `PPScanDelegate` instance.

- Fixed bug which caused image property of `PPImageMetadata` not take the image orientation into account

- Added Metadata for obtaining images that are processed for OCR

## 0.9.5

- Updates in OCR engine performance

- Added method in `PPOcrEngineOptions` to completely disable image processing inside BlinkOCR

## 0.9.4

- Added direct processing API which you can use to perform OCR on `UIImage` objects.

- Added NoCamera-sample project which shows how to use direct processing API

- You can now specify OcrEngine options to `RawOcrEngineParser` object.
        - in the options, you can customize OCR engine parameteres, like char whitelist used, minimal and maximal line sizes, etc.
        
- Updated OCR models with support for more special characters like currency symbols

## 0.9.3

- This version uses a new license key format. If you had a license key generated prior to v0.9.3, contact us so we can regenerate the license key for you.

- `PPCoordinator` class now exposes fewer public methods and properties.

- `PPScanningViewController`'s methods `resumeScanning` and `resumeScanningWithoutStateReset` merged into one `resumeScanningAndResetState:`. 
        - All calls to `resumeScanning` replace with `resumeScanningAndResetState:YES`.
        - All calls to `resumeScanningWithoutStateReset` replace with `resumeScanningAndResetState:NO`

## 0.9.2

- Naming changes in API (see Transition guide)
	- `PPBaseResult` renamed to `PPRecognizerResult`
	- `PPBaseResult` subclasses renamed accordingly
	- `PPOcrResult` renamed to PPOcrLayout

- Each `PPRecognizerResult` now has implemented `description` method for easier debugging

- Fixed orientation handling for case when overlay autorotates.

- Scanning region is now a property of Scanning view controller, and overlay view controller now delegates to this property.

## 0.9.1

- API consolidation, Bugfixes and improvements

## 0.9.0

- Initial functionality added for Raw text scanning, Price and Iban parsing.
- Initial documentation added
- Implemented Two sample apps
	- One for simple integration showing how OcrRecognizer can easily be included in the app
	- One with custom UI for FormScanning with Price, IBAN and Reference number parsing