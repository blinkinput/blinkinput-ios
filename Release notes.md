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