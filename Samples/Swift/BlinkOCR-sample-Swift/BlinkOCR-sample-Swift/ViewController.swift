//
//  ViewController.swift
//  BlinkOCR-sample-Swift
//
//  Created by Dino on 15/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import UIKit
import MobileCoreServices
import MicroBlink

class ViewController: UIViewController, PPScanningDelegate  {

    var rawOcrParserId : String = "Raw ocr"
    var priceParserId : String = "Price"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /**
     * Method allocates and initializes the Scanning coordinator object.
     * Coordinator is initialized with settings for scanning
     *
     *  @param error Error object, if scanning isn't supported
     *
     *  @return initialized coordinator
     */
    func coordinatorWithError(error: NSErrorPointer) -> PPCameraCoordinator? {
        
        NSLog("%@", PPCameraCoordinator.buildVersionString());

        /** 0. Check if scanning is supported */

        if (PPCameraCoordinator.isScanningUnsupported(for: PPCameraType.back, error: nil)) {
            return nil;
        }


        /** 1. Initialize the Scanning settings */

         // Initialize the scanner settings object. This initialize settings with all default values.
        let settings: PPSettings = PPSettings()


        /** 2. Setup the license key */

        // Visit www.microblink.com to get the license key for your app
        settings.licenseSettings.licenseKey = "YVNJMEOS-O7PXTS2J-2QGPSPRY-ZUJHTSYJ-2J35YFHB-4YYVZMCJ-2QAC2GEP-PLJG5NQS"
        // This license key is valid temporarily until 2017-06-20

        /**
         * 3. Set up what is being scanned. See detailed guides for specific use cases.
         * Here's an example for initializing raw OCR scanning.
         */

         // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
        let ocrRecognizerSettings = PPBlinkOcrRecognizerSettings()
        
        // We want raw OCR parsing
        let rawOcrFactory = PPRawOcrParserFactory()
        rawOcrFactory.isRequired = false;

        ocrRecognizerSettings.addOcrParser(rawOcrFactory, name: self.rawOcrParserId)

        // We want to parse prices from raw OCR result as well
        let priceOcrFactory = PPPriceOcrParserFactory()
        priceOcrFactory.isRequired = false;
        
        ocrRecognizerSettings.addOcrParser(priceOcrFactory, name: self.priceParserId)

        // Add the recognizer setting to a list of used recognizer
        settings.scanSettings.add(ocrRecognizerSettings)


        /** 4. Initialize the Scanning Coordinator object */

        let coordinator: PPCameraCoordinator = PPCameraCoordinator(settings: settings)

        return coordinator
    }

    @IBAction func didTapScan(_ sender: AnyObject) {

        /** Instantiate the scanning coordinator */
        let error : NSErrorPointer = nil
        let coordinator : PPCameraCoordinator? = self.coordinatorWithError(error: error)

        /** If scanning isn't supported, present an error */
        if coordinator == nil {
            let messageString: String = (error!.pointee?.localizedDescription) ?? ""
            UIAlertView(title: "Warning", message: messageString, delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }

        /** Allocate and present the scanning view controller */
        let scanningViewController: UIViewController = PPViewControllerFactory.cameraViewController(with: self, coordinator: coordinator!, error: nil);

        /** You can use other presentation methods as well */
        self.present(scanningViewController, animated: true, completion: nil)
    }
    
    func scanningViewController(_ scanningViewController: UIViewController?, didOutputResults results: [PPRecognizerResult]) {
        
        let scanConroller : PPScanningViewController = scanningViewController as! PPScanningViewController
        
        
        // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
        
        // first, pause scanning until we process all the results
        scanConroller.pauseScanning()
        
        // Collect data from the result
        for result in results {
            
            if(result.isKind(of: PPBlinkOcrRecognizerResult.self)) {
                let ocrRecognizerResult = result as! PPBlinkOcrRecognizerResult
                
                print("OCR results are:");
                print("Raw ocr: %@", ocrRecognizerResult.parsedResult(forName: self.rawOcrParserId))
                print("Price: %@", ocrRecognizerResult.parsedResult(forName: self.priceParserId))
                
                let ocrLayout : PPOcrLayout=ocrRecognizerResult.ocrLayout()
                print("Dimensions of ocrLayout are %@", NSStringFromCGRect(ocrLayout.box))
            }
        }
        
        // resume scanning while preserving internal recognizer state
        scanConroller.resumeScanningAndResetState(false);
    }

    func scanningViewControllerUnauthorizedCamera(_ scanningViewController: UIViewController){
        // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
    }

    func scanningViewController(_ scanningViewController: UIViewController, didFindError error: Error) {
        // Can be ignored. See description of the method
    }

    func scanningViewControllerDidClose(_ scanningViewController: UIViewController) {
        // As scanning view controller is presented full screen and modally, dismiss it
        self.dismiss(animated: true, completion: nil)
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismiss(animated: true, completion: nil)
    }
}

