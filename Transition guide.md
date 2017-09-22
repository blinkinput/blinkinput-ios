### Transition to 2.3.0

- Since Microblink.framework is a dynamic framework, you also need to **add it to embedded binaries section in General settings of your target.**

- Library size was reduced by removing all unnecessary components. One of the components removed was internal libz library. You now need to **add libz.tbd into "Linked frameworks and binaries" setting.**

- Microblink.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures. 

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

- `PPBlinkOcrRecognizerResult` and `PPBlinkOcrRecognizerSettings` are now deprecated. Use `PPDetectorRecognizerResult` and `PPDetectorRecognizerSettings` for templating or `PPBlinkInputRecognizerResult` and `PPBlinkInputRecognizerSettings` for segment scan
- `PPBarDecoderRecognizerResult` and `PPBarDecoderRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
- `PPZXingRecognizerResult` and `PPZXingRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
- deprecated `PPHelpDisplayMode`. It still works, but ideally, you should replace it with a custom logic for presenting help inside the application using the SDK
- simplified `PPOcrLayout` class (removed properties which were not used). If you used it previously, simply remove that code because it does not provide any value
- although `PPDateOcrParser` now returns `PPDateResult` object (which contains both `NSDate` and original `NSString` from which date was parsed), when obtaining parser result via `parserResultForName:` or `parserResultForName:parserGroup:` methods, you will be provided with string just like in previous versions. If you want `NSDate`, you should use methods `specificParsedResultForName:` or `specificParsedResultForName:parserGroup:` and cast `NSObject` they return into `NSDate`
- all recognizer results (classes that derive `PPRecognizerResult`) now have annotated nullability for their getters. Some of them used to assume non-null, while still returning `nil` sometimes. This has now been corrected and all getters are `_Nullable`

### Transition to 2.2.0

- No changes

### Transition to 2.1.2

- No changes

### Transition to 2.1.1

- No changes

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