### Transition to 2.1.0

- Removed PPOcrEngineOptions property from PPRegexOcrParserFactory and PPRawOcrParserFactory. Replaced property with setter method.

### Transition to 2.0.0

- `PPCameraCoordinator` now assumes the role of `PPCoordinator`. If you do not use your own camera management or Direct API you can rename all instances of `PPCoordinator` to `PPCameraCoordinator`
- `PPCoordinator` method `cameraViewControllerWithDelegate:` has been removed. To create `PPScanningViewControllers` you can now use `[PPViewControllerFactory cameraViewControllerWithDelegate: coordinator: error:]`
- Direct API is now located in `PPCoordinator`. To process image use 'processImage:' method and be sure to set 'PPCoordinatorDelegate' when creating 'PPCoordinator' to recieve scanning results and events. You can se processing image roi and processing orientation on 'PPImage' object.
- Methods of 'PPOverlayContainerViewController' protocol should now be called after camera view has appeared.

### Transition to 1.2.0

- Renamed `PPOcrRecognizerSettings` and `PPOcrRecognizerResult` to `PPBlinkOcrRecognizerSettings` and `PPBlinkOcrRecognizerResult` respectively

- PPOverlayViewController changed the way Overlay Subviews are added to the view hierarchy. Instead of calling `addOverlaySubview:` (which automatically added a view to view hierarachy), you now need to call `registerOverlaySubview:` (which registers subview for scanning events), and manually add subview to view hierarchy using `addSubview:` method. This change gives you more flexibility for adding views and managing autolayout and autoresizing masks. So, replace all calls to (assuming self is a `PPOverlayViewController` instance)
- PPScanDelegate has been renamed to PPScanningDelegate

```objective-c
[self addOverlaySubview:subview];
```

with 
```objective-c
[self registerOverlaySubview:subview];
[self.view addSubview:subview];
```

- Remove the old .embeddedframework package completely from your project

- Add new .framework and .bundle package to your project. Verify that Framework search path really contains a path to the .framework folder.

- If necessary, add all required system frameworks and libraries:

    - libc++.tbd
    - libiconv.tbd
    - AVFoundation.framework
    - AudioToolbox.framework
    - CoreMedia.framework
    - AssetsLibrary.framework
    - Accelerate.framework
	
- If you use `PPMetadataSettings` objects, 
	- `successfulScanFrame` property replace with `successfulFrame`
	- `currentVideoFrame` property replace with `currentFrame`

### Transition to 1.1.1

- No backwards incompatible changes.

### Transition to 1.1.0

- No backwards incompatible changes. See Release notes for a complete list of changes.

### Transition to 1.0.0

- If you're using direct API, just delete all calls to `PPCoordinator initializeRecognizers` and `PPCoordinator terminateRecognizers`. These calls are now performed internally

- `PPApp` class is no longer a part of the API. 

### Transition to 0.9.6

- `rotatedImage` property of `PPImageMetadata` no longer exists. Use `image` property instead, it correctly handles rotation.

- `PPMetadataSettings` was cleaned up - use the alternative names provided listed in the header file. 

### Transition to 0.9.5

- No changes

### Transition to 0.9.4

- No changes

### Transition to 0.9.3

- This version uses a new license key format. If you had a license key generated prior to v0.9.3, contact us so we can regenerate the license key for you.

- `PPCoordinator` class now exposes fewer public methods and properties.

- `PPScanningViewController`'s methods `resumeScanning` and `resumeScanningWithoutStateReset` merged into one `resumeScanningAndResetState:`. 
    
    - All calls to `resumeScanning` replace with `resumeScanningAndResetState:YES`.
   
    - All calls to `resumeScanningWithoutStateReset` replace with `resumeScanningAndResetState:NO`

### Transition to 0.9.2

- Classes representing scanning results were renamed. Renaming was performed to match naming convention of `PPRecognizerSettings` hierarcy: now each `PPRecognizerSettings` class has it's matching `PPRecognizerResult`. Replace all existing references to old class names with the new ones:

    - `PPBaseResult` was renamed to `PPRecognizerResult`. 

    - `PPOcrScanResult` was renamed to `PPOcrRecognizerResult`, this is the result of a recognizer whose settings are given with `PPOcrRecognizerSettings.`

- `PPOcrResult` (class representing a result of the OCR process, with individual characters, lines and blocks), was renamed to `PPOcrLayout`. Name change was introduced to further distinguish the class from `PPRecognizerResult` classes.

- Remove all references to `updateScanningRegion` method since it's now being called automatically in `setScanningRegion setter`.

### Transition to 0.9.1

- Framework was renamed to MicroBlink.embeddedframework. Remove the existing .embeddedframwork package from your project, and drag&drop MicroBlink.embeddedframework in the project explored of your Xcode project.

- If necessary, after the update, modify your framework search path so that it points to the  MicroBlink.embeddedframework folder.

- Main header of the framework was renamed to `<MicroBlink/Microblink.h>`. Change all references to previous header with the new one.

- method `[PPCoordinator isPhotoPaySupported]` was renamed to `[PPCoordinator isScanningSupported]`. Change all occurances of the method name.