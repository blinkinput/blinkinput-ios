## 0.9.6

- Added didOutputMetadata callback method to PPOverlayViewControllers

- Fixed bug which caused Overlay events to be called when direct (static) OCR processing is used. Direct OCR processing now only reports events to PPScanDelegate instance.

- Fixed bug which caused image property of PPImageMetadata not take the image orientation into account

- Added Metadata for obtaining images that are processed for OCR

## 0.9.5

- Updates in OCR engine performance

- Added method in PPOcrEngineOptions to completely disable image processing inside BlinkOCR

## 0.9.4

- Added direct processing API which you can use to perform OCR on UIIMage objects.

- Added NoCamera-sample project which shows how to use direct processing API

- You can now specify OcrEngine options to RawOcrEngineParser object.
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