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